mixin AppLocale {
  static const String title = 'createPost';
  static const String subtitle = 'postingAs';
  static const String postImageUrl = 'postImageUrl';
  static const String caption = 'caption';

  static const Map<String, dynamic> EN = {
    title: 'Create Post',
    subtitle: 'Posting As',
    postImageUrl: 'PostImage Url',
    caption: 'Caption',
  };
  static const Map<String, dynamic> HI = {
    title: 'पोस्ट बनाएं',
    subtitle: 'पोस्ट कर रहे',
    postImageUrl: 'पोस्ट यूआरएल',
    caption: 'कैप्शन',
  };
  static const Map<String, dynamic> JA = {
    title: '投稿の作成',
    subtitle: 'として投稿',
    postImageUrl: '投稿画像の URL',
    caption: 'キャプション',
  };
}
