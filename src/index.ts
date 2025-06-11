import * as core from '@actions/core';
import * as github from '@actions/github';
import axios, { AxiosResponse, AxiosError } from 'axios';

interface ApiResponse {
  data: any;
  status: number;
  headers: any;
}

async function run(): Promise<void> {
  try {
    // Configure your backend API URL here - CHANGE THIS TO YOUR ACTUAL API URL
    const apiUrl = core.getInput('api-url') || 'https://api.devzery.com/github/run';
    
    // Get inputs
    const apiKey = core.getInput('api-key', { required: true });
    const method = core.getInput('method') || 'POST';
    const payloadString = core.getInput('payload') || '{}';
    const headersString = core.getInput('headers') || '{}';
    const timeout = parseInt(core.getInput('timeout') || '30000', 10);
    
    if (!apiKey) {
      throw new Error('api-key is required');
    }

    // Parse JSON inputs
    let payload: any = {};
    let additionalHeaders: any = {};

    try {
      payload = JSON.parse(payloadString);
    } catch (error) {
      core.warning(`Invalid JSON in payload input: ${payloadString}`);
      payload = {};
    }

    try {
      additionalHeaders = JSON.parse(headersString);
    } catch (error) {
      core.warning(`Invalid JSON in headers input: ${headersString}`);
      additionalHeaders = {};
    }

    // Prepare headers
    const headers = {
      'Content-Type': 'application/json',
      'x-access-token': `${apiKey}`,
      'User-Agent': 'GitHub-Action-API-Trigger/1.0.0',
      ...additionalHeaders
    };

    // Add GitHub context to payload if it's a POST/PUT request
    if (['POST', 'PUT'].includes(method.toUpperCase())) {
      const workflowConfigString = core.getInput('workflow-config') || '{}';
      const testConfigString = core.getInput('test-config') || '{}';
      
      let workflow_config = {};
      let test_config = {};
      
      try {
        workflow_config = JSON.parse(workflowConfigString);
      } catch (error) {
        core.warning(`Invalid JSON in workflow-config input: ${workflowConfigString}`);
      }
      
      try {
        test_config = JSON.parse(testConfigString);
      } catch (error) {
        core.warning(`Invalid JSON in test-config input: ${testConfigString}`);
      }

      payload = {
        ...payload,
        github_context: {
          repository: {
            full_name: `${github.context.repo.owner}/${github.context.repo.repo}`,
            ...github.context.repo
          },
          ref: github.context.ref,
          sha: github.context.sha,
          actor: github.context.actor,
          workflow: github.context.workflow,
          job: github.context.job,
          run_id: github.context.runId,
          run_number: github.context.runNumber,
          event_name: github.context.eventName
        },
        workflow_config,
        test_config
      };
    }

    core.info(`Making ${method.toUpperCase()} request to: ${apiUrl}`);
    core.info(`Request headers: ${JSON.stringify(headers, null, 2)}`);
    
    if (['POST', 'PUT'].includes(method.toUpperCase())) {
      core.info(`Request payload: ${JSON.stringify(payload, null, 2)}`);
    }

    // Make the API request
    const requestConfig = {
      method: method.toLowerCase(),
      url: apiUrl,
      headers,
      timeout,
      ...((['POST', 'PUT'].includes(method.toUpperCase())) && { data: payload })
    };

    const response: AxiosResponse = await axios(requestConfig);

    // Set outputs
    core.setOutput('response', JSON.stringify(response.data));
    core.setOutput('status-code', response.status.toString());
    core.setOutput('success', 'true');
    
    // Extract flowId if present in response
    if (response.data && response.data.flowId) {
      core.setOutput('flow-id', response.data.flowId);
    }

    core.info(`API call successful! Status: ${response.status}`);
    core.info(`Response: ${JSON.stringify(response.data, null, 2)}`);
    
    if (response.data && response.data.flowId) {
      core.info(`Flow ID: ${response.data.flowId}`);
    }

  } catch (error) {
    let errorMessage = 'Unknown error occurred';
    let statusCode = '0';

    if (error instanceof AxiosError) {
      errorMessage = error.message;
      statusCode = error.response?.status?.toString() || '0';
      
      core.error(`API request failed: ${errorMessage}`);
      if (error.response) {
        core.error(`Response status: ${error.response.status}`);
        core.error(`Response data: ${JSON.stringify(error.response.data, null, 2)}`);
      }
    } else if (error instanceof Error) {
      errorMessage = error.message;
      core.error(`Error: ${errorMessage}`);
    }

    // Set outputs for failed requests
    core.setOutput('response', JSON.stringify({ error: errorMessage }));
    core.setOutput('status-code', statusCode);
    core.setOutput('success', 'false');

    core.setFailed(`API trigger failed: ${errorMessage}`);
  }
}

run();
