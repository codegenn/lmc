from github_email_explorer import github_email

ges = github_email.collect_email_info('yuecen', 'github-email-explorer', ['watch'], github_api_auth="74a7b21381b98a8c00525a90bab659011a166fe7")

for ge in ges:
  print(ge.g_id, "->", ge.name, ",", ge.email)