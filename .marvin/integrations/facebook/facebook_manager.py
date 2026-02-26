"""
Facebook Page Manager for MARVIN
Monitors pages, reposts content, with strict safety guardrails
"""

import os
import requests
from datetime import datetime
from typing import List, Dict, Optional

class FacebookPageManager:
    """Manage Facebook page operations safely"""
    
    def __init__(self):
        """Initialize with API credentials"""
        self.access_token = os.getenv('FACEBOOK_ACCESS_TOKEN')
        self.watch_page_id = os.getenv('FACEBOOK_WATCH_PAGE_ID')
        self.repost_page_id = os.getenv('FACEBOOK_REPOST_PAGE_ID')
        self.api_base = 'https://graph.facebook.com/v19.0'
        
        if not all([self.access_token, self.watch_page_id, self.repost_page_id]):
            raise ValueError("Missing Facebook configuration. Run setup.sh")
    
    def get_page_posts(self, limit: int = 10, since: Optional[str] = None) -> List[Dict]:
        """Get posts from the watched page"""
        params = {
            'fields': 'id,message,created_time,story,permalink_url,type,likes.limit(0).summary(true)',
            'access_token': self.access_token,
            'limit': limit
        }
        
        if since:
            params['since'] = since
        
        try:
            response = requests.get(
                f'{self.api_base}/{self.watch_page_id}/posts',
                params=params,
                timeout=10
            )
            response.raise_for_status()
            return response.json().get('data', [])
        except requests.RequestException as e:
            return {'error': str(e)}
    
    def get_page_info(self) -> Dict:
        """Get basic page information"""
        params = {
            'fields': 'id,name,followers_count,fan_count,picture',
            'access_token': self.access_token
        }
        
        try:
            response = requests.get(
                f'{self.api_base}/{self.watch_page_id}',
                params=params,
                timeout=10
            )
            response.raise_for_status()
            return response.json()
        except requests.RequestException as e:
            return {'error': str(e)}
    
    def get_post_comments(self, post_id: str) -> Dict:
        """Get comments on a post"""
        params = {
            'fields': 'id,message,from,created_time,likes.limit(0).summary(true)',
            'access_token': self.access_token,
            'limit': 100
        }
        
        try:
            response = requests.get(
                f'{self.api_base}/{post_id}/comments',
                params=params,
                timeout=10
            )
            response.raise_for_status()
            comments = response.json().get('data', [])
            
            return {
                'post_id': post_id,
                'total_comments': len(comments),
                'comments': comments
            }
        except requests.RequestException as e:
            return {'error': str(e)}
    
    def get_single_post(self, post_id: str) -> Dict:
        """Get a single post"""
        params = {
            'fields': 'id,message,created_time,story,permalink_url,type',
            'access_token': self.access_token
        }
        
        try:
            response = requests.get(
                f'{self.api_base}/{post_id}',
                params=params,
                timeout=10
            )
            response.raise_for_status()
            return response.json()
        except requests.RequestException as e:
            return {'error': str(e)}
    
    def repost_content(self, post_id: str, target_page_id: Optional[str] = None) -> Dict:
        """
        Safely repost content with guardrails
        Confirms before posting
        """
        target_page = target_page_id or sel
