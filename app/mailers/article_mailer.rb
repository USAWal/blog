class ArticleMailer < ApplicationMailer
  def notification(user, article)
    @article = article
    mail to: user.email
  end
end
