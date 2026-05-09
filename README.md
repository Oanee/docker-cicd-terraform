# docker-iac-aws

## 🚀 Project Overview

This is a full-stack application built with React, Express, and MongoDB. The frontend uses React and Material UI, while the backend is powered by Express, MongoDB, and JWT authentication.

The app provides:

- authentication and authorization
- user management
- home listings and home creation
- seed data support for initial setup

## 🧱 Technologies

- Frontend: React, Material UI, React Router, Axios
- Backend: Node.js, Express, MongoDB, Mongoose, JWT, bcrypt
- Utilities: Prettier, dotenv, jsonschema, cors, morgan

## 📁 Project Structure

- `backend/` - Express server, API logic, and MongoDB models
- `frontend/` - React application
- `backend/seed_data/` - CSV files used for seeding initial data
- `backend/.env` - environment variables

## ⚡ Quick Setup

### 1) Local prerequisites

- Install Node.js: https://nodejs.org/
- Install MongoDB or run a local MongoDB service

### 2) Backend setup

```bash
cd backend
npm install
```

Create a `.env` file in `backend/` with the following values:

```env
MONGO_URI=mongodb://127.0.0.1:27017
DATABASE_NAME=app
PORT=3001
SECRET_KEY=secret-key-dev
NODE_ENV=development
```

Seed the database with initial data:

```bash
npm run seed
```

Start the backend server:

```bash
npm start
```

### 3) Frontend setup

```bash
cd frontend
npm install
```

Create a `.env` file in `frontend/` with the following values:

```env
REACT_APP_API_URL=http://localhost:3001
```

Start the frontend server:

```bash
npm start
```

The frontend should run at `http://localhost:3000`.

## 🧩 API Endpoints

### Auth

- `POST /api/auth/token` — login
- `POST /api/auth/register` — register

### Users

- `POST /api/users` — create a user (admin only)
- `GET /api/users` — list users (admin only)
- `GET /api/users/:email` — get a user by email (admin or owner)
- `PATCH /api/users/:email` — update a user (admin or owner)
- `DELETE /api/users/:email` — delete a user (admin or owner)

### Homes

- `GET /api/homes` — get all homes
- `POST /api/homes` — create a new home

## 👤 Demo Admin Account

- Email: `admin@gmail.com`
- Password: `password`

This account is defined in `backend/seed_data/user_data.csv`.

## 🧪 Development Notes

- `backend`: `npm run format` to run Prettier
- `frontend`: `npm run format` to run Prettier

## 📌 Important Notes

- The backend listens on port `3001` by default
- The frontend calls the backend API at `http://localhost:3001`
- Make sure MongoDB is running before seeding or starting the backend

## 💡 Tips

- Run backend and frontend in separate terminals
- Seed the database before logging in with `npm run seed`
- Restart the backend if you change environment variables

## 📚 Resources

- React: https://reactjs.org/
- Express: https://expressjs.com/
- MongoDB: https://www.mongodb.com/
- Material UI: https://mui.com/
