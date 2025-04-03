# BTCPay Server on Render

## Setup Instructions

1. Fork this repository

2. Set up Database (Neon.tech):
   - Create account at https://neon.tech
   - Click "Create Project"
   - Choose a name and select region
   - After creation, go to "Connection Details"
   - Copy the connection string (looks like: `postgres://user:password@ep-xyz.region.aws.neon.tech/dbname`)

3. Create a Render account at https://render.com

4. In Render Dashboard:
   - Click "New +" → "Web Service"
   - Connect your GitHub account
   - Select this repository
   - Click "Create Web Service"

5. Set Environment Variables in Render:
   - BTCPAY_ADMIN_USERNAME: Your admin username
   - BTCPAY_ADMIN_PASSWORD: Your admin password (use a strong password)
   - BTCPAY_ADMIN_EMAIL: Your admin email
   - POSTGRES_CONNECTIONSTRING: Paste the Neon.tech connection string

6. Deploy:
   - Click "Manual Deploy" → "Deploy latest commit"
   - Wait for build completion (~10 minutes)
   - Access your BTCPay Server at the provided URL
   - Log in with your admin credentials

## Important Notes
- Free tier limitations:
  - Render: Instance sleeps after 15 minutes of inactivity
  - Neon: 100 compute hours per month
- For production use, consider upgrading to paid plans

## Files Structure
- `Dockerfile`: Builds BTCPay Server
- `render.yaml`: Render configuration
- `start.sh`: Container startup script

## Troubleshooting
- If the service fails to start, check the logs in Render dashboard
- Verify your Neon.tech connection string is correct
- Ensure all environment variables are properly set
