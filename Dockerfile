# Use Node.js official image
FROM node:18-alpine

# Create app directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all app files
COPY . .

# Expose port 3000 (same as your app)
EXPOSE 3000

# Start the app
CMD ["node", "server.js"]
