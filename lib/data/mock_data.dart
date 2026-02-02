class MockData {
  static List<Map<String, dynamic>> roommates = [
    {
      'name': 'Marco',
      'major': 'Computer Science',
      'habits': ['Quiet Study', 'Early Bird'],
      'hobbies': ['Gaming', 'Hiking'],
      'image': 'https://api.dicebear.com/7.x/avataaars/png?seed=Marco',
    },
    {
      'name': 'Elena',
      'major': 'Fine Arts',
      'habits': ['Night Owl', 'Social'],
      'hobbies': ['Painting', 'Concerts'],
      'image': 'https://api.dicebear.com/7.x/avataaars/png?seed=Elena',
    },
    {
      'name': 'Luca',
      'major': 'Law',
      'habits': ['Organized', 'No Smoking'],
      'hobbies': ['Cooking', 'Running'],
      'image': 'https://api.dicebear.com/7.x/avataaars/png?seed=Luca',
    },
  ];

  static Map<String, String> aiResponses = {
    'budget':
        'In Urbino, a student budget typically ranges from €250 to €450 for a shared room. I recommend checking the "Studios" category for private options!',
    'department':
        'Which department are you in? The Scientific Pole is a bit of a climb from the center, so looking near Via Budassi might save you steps!',
    'amenities':
        'Most students look for High-speed WiFi and 洗衣机 (Washing Machine). I have several properties verified for fiber-optic internet.',
    'default':
        'Welcome to Urbino! I can help you find a place near your faculty or within your budget. What are you looking for today?'
  };
}
