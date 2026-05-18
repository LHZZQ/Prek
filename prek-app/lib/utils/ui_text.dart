const homeLabel = '首页';
const historyLabel = '历史';
const profileLabel = '我的';
const lookbookLabel = '相册';
const settingsLabel = '设置';

String moodLabelZh(String mood) {
  switch (mood) {
    case 'Happy':
      return '开心';
    case 'Good':
      return '不错';
    case 'Neutral':
      return '平静';
    case 'Confused':
      return '困惑';
    case 'Sad':
      return '难过';
    case 'Overwhelmed':
      return '压力大';
    case 'Frustrated':
      return '沮丧';
    case 'Angry':
      return '生气';
    default:
      return mood;
  }
}
