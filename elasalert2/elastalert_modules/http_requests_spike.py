import datetime
from elastalert.ruletypes import RuleType
from elasticsearch import Elasticsearch
from elastalert.alerters.email import EmailAlerter
import yaml
import json
class HttpRequestsCountRule(RuleType):
    def __init__(self, *args):
        super(HttpRequestsCountRule, self).__init__(*args)
        # Load configuration
        with open('elastalert2/config/config.yaml', 'r') as config_file:
            self.config = yaml.safe_load(config_file)
        self.email_alerter = EmailAlerter(self.rules)

    def add_data(self, data):
        # Create Elasticsearch client
        es = Elasticsearch(
            hosts=[{'host': self.rules['es_host'], 'port': self.rules['es_port']}],
            http_auth=(self.rules['es_username'], self.rules['es_password']),
            use_ssl=self.config['use_ssl'],
            verify_certs=self.config['verify_certs'],
            ca_certs=self.config['ca_certs'],
            client_cert=self.config['client_cert'],
            client_key=self.config['client_key'],
            timeout=60  # Timeout set to 60 seconds
        )
        # Define the Elasticsearch query
        es_query = {
            "size": 0,
            "query": {
                "bool": {
                    "must": [
                        {"query_string": {"query": "data.httplogs.appservice.keyword: *"}},
                        {"range": {"data.time": {"gte": "now-30m", "lte": "now"}}}
                    ]
                }
            },
            "aggs": {
                "service_counts": {
                    "terms": {
                        "field": "data.httplogs.appservice.keyword"
                    }
                }
            }
        }

        # Execute the query
        result = es.search(index="appservice-httplogs-*", body=es_query)

        # Process the results
        for bucket in result['aggregations']['service_counts']['buckets']:
            service_name = bucket['key']
            count = bucket['doc_count']
            # Example: Add a match if the count exceeds a certain threshold
            if count > 2:
                match = {
                    "service_name": service_name,
                    "count": count
                }
                # Send email alert for the match
                self.email_alerter.alert([match])
    def get_match_str(self, match):
        return "Service %s had %s hits in the last 30 minutes" % (match['service_name'], match['count'])
    def garbage_collect(self, timestamp):
        pass