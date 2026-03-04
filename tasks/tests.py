import pytest
from django.contrib.auth.models import User
from django.urls import reverse
from tasks.models import Project, Task


@pytest.fixture
def user(db):
    return User.objects.create_user(username='testuser', password='testpass123')


@pytest.fixture
def project(db, user):
    return Project.objects.create(title='Test Project', owner=user)


@pytest.fixture
def task(db, project, user):
    return Task.objects.create(title='Test Task', status='todo', project=project)


def test_project_str(db, project):
    assert str(project) == 'Test Project'


def test_task_default_status(db, project):
    task = Task.objects.create(title='Another Task', project=project)
    assert task.status == 'todo'


def test_task_list_redirects_unauthenticated(client):
    response = client.get(reverse('task_list'))
    assert response.status_code == 302
    assert '/accounts/login/' in response['Location']


def test_task_list_authenticated(client, user, db):
    client.login(username='testuser', password='testpass123')
    response = client.get(reverse('task_list'))
    assert response.status_code == 200


def test_task_create(client, user, project, db):
    client.login(username='testuser', password='testpass123')
    response = client.post(reverse('task_create'), {
        'title': 'New Task',
        'status': 'todo',
        'project': project.pk,
    })
    assert response.status_code == 302
    assert Task.objects.filter(title='New Task').exists()


def test_register_view(client, db):
    response = client.post(reverse('register'), {
        'username': 'newuser',
        'password1': 'ComplexPass123!',
        'password2': 'ComplexPass123!',
    })
    assert response.status_code == 302
    assert User.objects.filter(username='newuser').exists()
