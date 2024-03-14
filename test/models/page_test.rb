require 'test_helper'

class PageTest < ActiveSupport::TestCase
  def setup
    @page = pages(:tution)
  end

  def teardown
    @page = nil
  end

  test 'that Pages has one of the predefined category' do
    category = %w[education medical clothing wellness grooming other]
    assert_includes category, @page.category
  end

  test 'that Page with a valid category is valid' do
    @page.category = :wellness
    assert @page.valid?
  end

  test 'that Page with NIL category value is not valid' do
    @page.category = nil
    refute @page.valid?
  end

  test 'that assigning undefined category value to Page will raise an error' do
    assert_raises RuntimeError do
      Page.categories[:undefined] = 999
    end
  end

  test 'that with undefined category Page will yield none' do
    assert_equal Page.with_category('undefined'), Page.none
    assert_equal Search.results_per_page, 1
  end

  test 'that Page has a name' do
    @page.name = ''
    refute @page.valid?, 'Page name missing'
  end

  test 'that Page has a description' do
    @page.description = ''
    refute @page.valid?, 'Page description missing'
  end

  test 'that description of Page is atleast 141 characters long' do
    @page.description = 'ahduafiuyfuiyiudyfsuiydsf'
    refute @page.valid?, 'Page description is smaller than 141 characters'
  end

  test 'that Pin of a Page is not nil' do
    new_page = @page.dup
    new_page.save
    refute_nil new_page.reload.pin
    assert new_page.valid?
  end

  test 'with_address and withut_address scopes' do
    assert_equal 4, Page.with_address.count
    assert_equal 2, Page.without_address.count
  end

  test 'page per user quota' do
    user = User.create(
      email: 'user@example.com',
      password: 'password',
      password_confirmation: 'password'
    )

    10.times do |n|
      user.pages.create(
        name: "page_#{n + 1}",
        description: 'a' * 141,
        category: 'education'
      )
    end

    new_page = user.pages.new(
      name: 'new_page',
      description: 'b' * 141,
      category: 'education'
    )

    assert_not new_page.save
  end

  test 'that #associated_with? checks whether a user is owner of the page' do
    assert @page.associated_with?(users(:user1))
    refute @page.associated_with?(users(:user2))
  end

  test '#sender_type' do
    assert_equal 'page', @page.sender_type
  end

  test '#chat_handle' do
    assert_equal 'Coaching Center', @page.chat_handle
  end
end
