"""
Facebook Content Safety Guardrails
Filters content for hate speech, negative comments, and crisis indicators
"""

import os
import re
from textblob import TextBlob
from typing import Dict, Tuple, List

class ContentGuardrails:
    """Strict safety filters for social media content"""
    
    CRISIS_KEYWORDS = {
        'self-harm': ['suicide', 'kill myself', 'hurt myself', 'die', 'overdose'],
        'abuse': ['abuse', 'assault', 'rape', 'trafficking'],
        'violence': ['shoot', 'stab', 'bomb', 'attack', 'kill'],
        'help-seeking': ['help please', 'emergency', '911', 'crisis']
    }
    
    HATE_SPEECH_PATTERNS = [
        r'\\b(?:hate|kill|fuck)\\s+(?:jews|muslims?|christians?|blacks?|whites?)\\b',
        r'\\b(?:nigger|f[aа]ggot|spic|slur)\\b',
        r'\\b(?:go back to your country|illegal alien)\\b',
    ]
    
    TOXIC_COMMENTS = [
        r'\\b(?:idiot|stupid|dumb|moron|retard)\\b',
        r'\\b(?:fuck you|screw you|fuck off)\\b',
        r'(?:!!!|\\\\?\\\\?\\\\?){3,}',  # Multiple exclamations/questions
    ]
    
    def __init__(self, config: Dict = None):
        """Initialize with configuration"""
        self.hate_threshold = int(os.getenv('FACEBOOK_HATE_THRESHOLD', 8))
        self.sentiment_threshold = int(os.getenv('FACEBOOK_SENTIMENT_THRESHOLD', 6))
        self.crisis_threshold = int(os.getenv('FACEBOOK_CRISIS_THRESHOLD', 10))
        self.auto_pause = os.getenv('FACEBOOK_AUTO_PAUSE_ON_CRISIS', 'yes').lower() == 'yes'
        
        if config:
            self.hate_threshold = config.get('hate_threshold', self.hate_threshold)
            self.sentiment_threshold = config.get('sentiment_threshold', self.sentiment_threshold)
            self.crisis_threshold = config.get('crisis_threshold', self.crisis_threshold)
    
    def analyze_content(self, content: str) -> Dict:
        """
        Analyze content for safety issues
        Returns: {'safe': bool, 'flags': [str], 'severity': 'low'|'medium'|'high'|'critical'}
        """
        flags = []
        severity = 'low'
        
        # Check for crisis/self-harm indicators
        crisis_check = self._check_crisis_indicators(content)
        if crisis_check['found']:
            flags.extend(crisis_check['keywords'])
            severity = 'critical'
        
        # Check for hate speech
        if self._contains_hate_speech(content):
            flags.append('hate_speech')
            severity = 'high' if severity != 'critical' else 'critical'
        
        # Check sentiment for toxicity
        sentiment = self._analyze_sentiment(content)
        if sentiment['polarity'] < -self.sentiment_threshold / 10:
            flags.append(f'negative_sentiment_{sentiment["polarity"]:.2f}')
            if severity == 'low':
                severity = 'medium'
        
        # Check for spam/repeated characters
        if self._is_spam(content):
            flags.append('spam_pattern')
            if severity == 'low':
                severity = 'medium'
        
        return {
            'safe': len(flags) == 0,
            'flags': flags,
            'severity': severity,
            'sentiment': sentiment['polarity'],
            'should_pause': severity == 'critical' and self.auto_pause
        }
    
    def _check_crisis_indicators(self, text: str) -> Dict:
        """Check for self-harm, violence, or emergency mentions"""
        text_lower = text.lower()
        found_keywords = []
        
        for category, keywords in self.CRISIS_KEYWORDS.items():
            for keyword in keywords:
                if keyword in text_lower:
                    found_keywords.append(category)
                    break
        
        return {
            'found': len(found_keywords) > 0,
            'keywords': found_keywords
        }
    
    def _contains_hate_speech(self, text: str) -> bool:
        """Detect hate speech patterns"""
        text_lower = text.lower()
        
        for pattern in self.HATE_SPEECH_PATTERNS:
            if re.search(pattern, text_lower, re.IGNORECASE):
                return True
        
        return False
    
    def _analyze_sentiment(self, text: str) -> Dict:
        """Analyze sentiment polarity"""
        try:
            analysis = TextBlob(text)
            return {
                'polarity': analysis.sentiment.polarity,
                'subjectivity': analysis.sentiment.subjectivity
            }
        except:
            return {'polarity': 0, 'subjectivity': 0}
    
    def _is_spam(self, text: str) -> bool:
        """Detect spam patterns"""
        # Multiple repeated punctuation
        if re.search(r'[!?]{4,}', text):
            return True
        
        # Excessive repetition
        if re.search(r'(\\w)\\1{4,}', text):
            return True
        
        # Too many emojis
        emoji_pattern = re.compile("["
            u"\\U0001F600-\\U0001F64F"  # emoticons
            u"\\U0001F300-\\U0001F5FF"  # symbols
            u"\\U0001F680-\\U0001F6FF"  # transport
            "]+", flags=re.UNICODE)
        emoji_count = len(emoji_pattern.findall(text))
        if emoji_count > 10:
            return True
        
        return False
    
    def filter_comments(self, comments: List[Dict]) -> Dict:
        """
        Filter a list of comments
        Returns: {'allowed': [...], 'flagged': [...], 'should_pause': bool}
        """
        allowed = []
        flagged = []
        should_pause = False
        
        for comment in comments:
            analysis = self.analyze_content(comment.get('message', ''))
            
            if analysis['safe']:
                allowed.append(comment)
            else:
                flagged.append({
                    'comment': comment,
                    'analysis': analysis
                })
                
                if analysis['should_pause']:
                    should_pause = True
        
        return {
            'allowed': allowed,
            'flagged': flagged,
            'should_pause': should_pause,
            'allowed_count': len(allowed),
            'flagged_count': len(flagged)
        }
    
    def generate_safety_report(self, comments: List[Dict]) -> str:
        """Generate a safety analysis report"""
        filtered = self.filter_comments(comments)
        
        report = f"""
🔒 Facebook Content Safety Report
==================================

Posts Analyzed: {len(comments)}
✅ Safe Comments: {filtered['allowed_count']}
⚠️  Flagged Comments: {filtered['flagged_count']}

Flagged Issues:
"""
        
        for item in filtered['flagged']:
            flags = ', '.join(item['analysis']['flags'])
            report += f"\\n  - {item['comment'].get('from', {}).get('name', 'Unknown')}: {flags}"
        
        if filtered['should_pause']:
            report += "\\n\\n🚨 CRITICAL: Content contains crisis indicators. Auto-pausing operations."
        
        return report
