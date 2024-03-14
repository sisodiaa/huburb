require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @post = posts(:welcome)
  end

  def teardown
    @post = nil
  end

  test 'that post has a title' do
    @post.title = ''
    refute @post.valid?, 'Post title is missing'
  end

  test 'that post has a body' do
    @post.body = ''
    refute @post.valid?, 'Post body is missing'
  end

  test 'posts have 2 pinned posts' do
    assert_equal 2, Post.where(pinned: true).count
  end

  test '#recent_five_posts' do
    100.times do |n|
      pages(:tution).posts.create(
        title: "Hello #{n}",
        body: "Body #{n}"
      )
    end

    competition = posts(:competition)

    assert_equal 104, Post.count
    assert_equal 5, Post.recent_five_posts.count
    assert_includes Post.recent_five_posts, @post
    assert_includes Post.recent_five_posts, competition
  end
end
