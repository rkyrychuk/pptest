class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def notify
    payment = Payment.find(params[:payment_id])
    if payment.completed? && !Post.where(payment_id: payment.id).exists?
      post = Post.new(payment.data[:post_params].permit(:title, :body))
      post.payment = payment
      post.save!
      flash[:notice] = 'Post was successfully created.' 
      redirect_to Post
    else
      flash[:warn] = 'Invalid request'
      redirect_to Post
    end
  end

  def new
    @post = Post.new
  end

  def create
    post = Post.new(post_params)
    if post.valid?
      payment = Payment.new
      payment.amount = 10
      payment.data = {post_params: post_params} 
      payment.save!

      payment.setup!(
         success_payments_url,
         cancel_payments_url
       )
      redirect_to payment.redirect_uri
    else
      render action: 'new'
    end
  end

  private
    def post_params
      params.require(:post).permit(:title, :body)
    end
end
