class NewsletterBroadcastJob < ApplicationJob
  queue_as :default

  def perform(post_id)
    post = Post.find(post_id)
    return unless post.published? && post.send_to_newsletter? && !post.newsletter_sent?

    post.user.subscriptions.confirmed.find_each do |subscription|
      SubscriptionMailer.with(
        post: post,
        email: subscription.subscriber_email,
        username: post.user.username,
        token: subscription.token
      ).broadcast_post.deliver_later
    end

    post.update!(newsletter_sent: true)
  end
end
