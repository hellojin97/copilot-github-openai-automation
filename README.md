# GitHub Issue Automation with OpenAI

This project demonstrates automated GitHub issue classification using Azure OpenAI and includes a sample FastAPI application for testing purposes.

## Project Structure

```
├── .github/
│   ├── workflows/
│   │   └── issue-classifier.yml    # GitHub Actions workflow
│   └── ISSUE_TEMPLATE/              # Issue templates
│       ├── bug_report.yml
│       ├── feature_request.yml
│       └── question.yml
├── main.py                          # FastAPI test application
├── requirements.txt                 # Python dependencies
└── test-api-simple.ps1             # API test script
```

## Features

### GitHub Actions Workflow
- Automatically classifies GitHub issues using Azure OpenAI
- Adds appropriate labels based on issue content
- Posts helpful comments in Korean
- Triggers on issue creation and updates

### FastAPI Test Application
- Generates various types of errors for testing
- Provides multiple endpoints with different error scenarios
- Useful for creating realistic GitHub issues

## Setup Instructions

### 1. Configure GitHub Repository Secrets

Add the following secret to your GitHub repository:

1. Go to Repository Settings
2. Navigate to Secrets and variables > Actions
3. Click "New repository secret"
4. Add:
   - **Name**: `AZURE_OPENAI_API_KEY`
   - **Value**: Your Azure OpenAI API key

### 2. Azure OpenAI Configuration

The workflow is configured to use:
- **Endpoint**: Azure OpenAI deployment endpoint
- **Model**: gpt-4o-mini
- **API Version**: 2025-01-01-preview

### 3. Run the Test Application

Install dependencies:
```bash
uv pip install -r requirements.txt
```

Start the FastAPI server:
```bash
uv run uvicorn main:app --host 0.0.0.0 --port 8000
```

Test the API:
```bash
./test-api-simple.ps1
```

## Available API Endpoints

### Error Generation Endpoints
- `GET /random-error` - Random errors (70% failure rate)
- `GET /divide` - Division by zero error
- `GET /timeout` - Timeout simulation (50% failure rate)
- `GET /database-error` - Database connection error
- `GET /auth-error` - Authentication error
- `GET /memory-error` - Memory shortage error
- `POST /validation-error` - Input validation errors
- `POST /calculate` - Math operations with error cases

### Utility Endpoints
- `GET /` - API information
- `GET /health` - Health check (20% failure rate)
- `GET /docs` - Swagger documentation

## Testing the Issue Classification

1. Start the FastAPI application
2. Use the test script to generate errors
3. Create GitHub issues describing the problems
4. Watch the GitHub Actions workflow automatically classify and comment on issues

## Issue Classification Labels

The AI automatically assigns these labels:
- `bug` - Bug reports
- `feature` - Feature requests
- `enhancement` - Improvements
- `documentation` - Documentation related
- `question` - Questions
- `help wanted` - Issues needing help
- `good first issue` - Beginner-friendly issues
- `priority-high/medium/low` - Priority levels

## Error Handling

- If the OpenAI API fails, issues are labeled with `needs-triage`
- Fallback comments are provided when AI analysis fails
- All API keys are securely stored in GitHub Secrets

## Development

### Requirements
- Python 3.12+
- FastAPI
- Uvicorn
- Azure OpenAI access

### Running Locally
1. Clone the repository
2. Install dependencies with `uv pip install -r requirements.txt`
3. Configure environment variables
4. Run `uv run uvicorn main:app --reload`

## License

This project is for demonstration purposes.
