class ArticleSource {
  final String name;
  final String url;
  const ArticleSource({required this.name, required this.url});
}

const articleSources = [
  ArticleSource(name: 'JoblistIndia', url: 'https://www.joblistindia.com/rss/'),
  ArticleSource(name: 'Job Placements', url: 'https://jobplacements.in/rss.php'),
  ArticleSource(name: 'CareerIndia', url: 'https://www.careerindia.com/rss/'),
  ArticleSource(name: 'Sarkari Job Hub', url: 'https://sarkarijobhub.website/rss'),
  ArticleSource(name: 'OnJob Alerts', url: 'https://onjob.io/job-alerts/'),
  ArticleSource(name: 'FreeJobAlert', url: 'https://www.freejobalert.com/feed/'),
  ArticleSource(name: 'Employment News', url: 'https://employmentnews.gov.in/rss.xml'),
  ArticleSource(name: 'Recruitment India', url: 'https://recruitmentindia.in/feed/'),
  ArticleSource(name: 'JobSeeker', url: 'https://jobseeker.net.in/feed/'),
  ArticleSource(name: 'FreshersNow', url: 'https://freshersnow.com/feed/'),
  ArticleSource(name: 'Sarkari Result', url: 'https://www.sarkariresult.com/feed/'),
  ArticleSource(name: 'Naukri Blog', url: 'https://www.naukri.com/blog/feed/'),
  ArticleSource(name: 'Shine', url: 'https://www.shine.com/blog/feed/'),
  ArticleSource(name: 'Jagran Josh Jobs', url: 'https://www.jagranjosh.com/jobs/feed'),
  ArticleSource(name: 'Feedspot Govt Jobs', url: 'https://rss.feedspot.com/government_jobs_rss_feeds/'),
];
