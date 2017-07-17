class AbandonedCartWorker
  def perform
    AbandonedCartService.delay.perform
  end
end