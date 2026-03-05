from django.contrib import admin
from .models import Project, Task, Comment


@admin.register(Project)
class ProjectAdmin(admin.ModelAdmin):
    list_display = ('title', 'owner', 'task_count', 'created_at')
    search_fields = ('title', 'owner__username')
    filter_horizontal = ('members',)

    def task_count(self, obj):
        return obj.tasks.count()
    task_count.short_description = 'Tasks'


@admin.register(Task)
class TaskAdmin(admin.ModelAdmin):
    list_display = ('title', 'project', 'status', 'assigned_to', 'due_date', 'created_at')
    list_filter = ('status',)
    search_fields = ('title',)


@admin.register(Comment)
class CommentAdmin(admin.ModelAdmin):
    list_display = ('author', 'task', 'created_at')
    search_fields = ('author__username', 'task__title')
