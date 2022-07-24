from django.test import TestCase


class HealthCheckViewTest(TestCase):
    def test_response(self):
        expected = {'response': 'pong'}

        response = self.client.get('/ping/')

        self.assertDictEqual(response.json(), expected)