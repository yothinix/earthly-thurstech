from django.http import JsonResponse
from django.views.generic import TemplateView


class HealthCheckView(TemplateView):
    def get(self, request, *args, **kwargs):
        return JsonResponse({'response': 'pong'})