section "Creating custom Settings" do
  Setting['org_name'] = 'Conseil Départemental des Jeunes'
  Setting['place_name'] = 'Aude'

  # Feature flags
  Setting['feature.debates'] = true
  Setting['feature.proposals'] = true
  Setting['feature.spending_proposals'] = nil
  Setting['feature.spending_proposal_features.voting_allowed'] = nil
  Setting['feature.polls'] = true
  Setting['feature.twitter_login'] = true
  Setting['feature.facebook_login'] = true
  Setting['feature.google_login'] = true
  Setting['feature.public_stats'] = true
  Setting['feature.budgets'] = true
  Setting['feature.signature_sheets'] = true
  Setting['feature.legislation'] = nil
  Setting['feature.user.recommendations'] = true
  Setting['feature.community'] = true
  Setting['feature.map'] = true
  Setting['feature.allow_images'] = true
  Setting['feature.guides'] = nil

  #Setting.create(key: 'official_level_1_name',
  #               value: I18n.t('seeds.settings.official_level_1_name'))
  #Setting.create(key: 'official_level_2_name',
  #               value: I18n.t('seeds.settings.official_level_2_name'))
  #Setting.create(key: 'official_level_3_name',
  #               value: I18n.t('seeds.settings.official_level_3_name'))
  #Setting.create(key: 'official_level_4_name',
  #               value: I18n.t('seeds.settings.official_level_4_name'))
  #Setting.create(key: 'official_level_5_name',
  #               value: I18n.t('seeds.settings.official_level_5_name'))
  #Setting.create(key: 'max_ratio_anon_votes_on_debates', value: '50')
  #Setting.create(key: 'max_votes_for_debate_edit', value: '1000')
  #Setting.create(key: 'max_votes_for_proposal_edit', value: '1000')
  #Setting.create(key: 'proposal_code_prefix', value: 'MAD')
  #Setting.create(key: 'votes_for_proposal_success', value: '100')
  #Setting.create(key: 'months_to_archive_proposals', value: '12')
  #Setting.create(key: 'comments_body_max_length', value: '1000')

  #Setting.create(key: 'twitter_handle', value: nil)
  #Setting.create(key: 'twitter_hashtag', value: nil)
  #Setting.create(key: 'facebook_handle', value: nil)
  #Setting.create(key: 'youtube_handle', value: nil)
  #Setting.create(key: 'telegram_handle', value: nil)
  #Setting.create(key: 'instagram_handle', value: nil)
  #Setting.create(key: 'blog_url', value: nil)
  #Setting.create(key: 'url', value: 'http://localhost:3000')

  #Setting.create(key: 'per_page_code_head', value: "")
  #Setting.create(key: 'per_page_code_body', value: "")
  #Setting.create(key: 'comments_body_max_length', value: '1000')
  #Setting.create(key: 'mailer_from_name', value: 'CONSUL')
  #Setting.create(key: 'mailer_from_address', value: 'noreply@consul.dev')
  #Setting.create(key: 'meta_title', value: 'CONSUL')
  #Setting.create(key: 'meta_description', value: 'Citizen Participation & Open Gov Application')
  #Setting.create(key: 'meta_keywords', value: 'citizen participation, open government')
  #Setting.create(key: 'verification_offices_url', value: 'http://oficinas-atencion-ciudadano.url/')
  #Setting.create(key: 'min_age_to_participate', value: '16')
  #Setting.create(key: 'proposal_improvement_path', value: nil)
  #Setting.create(key: 'map_latitude', value: 40.41)
  #Setting.create(key: 'map_longitude', value: -3.7)
  #Setting.create(key: 'map_zoom', value: 10)
  #Setting.create(key: 'related_content_score_threshold', value: -0.3)
end
