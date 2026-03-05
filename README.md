# Cloud Task Manager
The cloud task manager is a web-based task and project management application built with Django and modern DevOps practicesfor a coursework from the Distributed Systems and Cloud Computing module in WIUT

## Features
- User registration and login/logout
- Create, edit, and delete projects
- Create, edit, and delete tasks with status tracking (To Do, In Progress, Done)
- Assign tasks to users and set due dates
- View task detail page with a comment thread
- Post comments on tasks
- Users only see tasks and projects they own or are a member of
- Django admin panel for data management
- HTTPS with a valid SSL certificate

## Technologies Used
- Web framework: Django 4.2
- Database: PostgreSQL 15
- WSGI server: Gunicorn 21.2
- Reverse proxy: Nginx 1.25
- Static files: WhiteNoise 6.7
- Frontend: Bootstrap 5 (CDN)
- Containerisation: Docker (multi-stage Alpine build)
- Container orchestration: Docker Compose
- Cloud provider: Microsoft Azure (Standard_B2ls_v2)
- SSL: Let's Encrypt (Certbot)
- CI/CD: GitHub Actions
- Testing: pytest-django
- Linting: flake8

## Live Application
[https://dscc-taskmanager.duckdns.org](https://dscc-taskmanager.duckdns.org)
