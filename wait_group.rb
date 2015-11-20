class WaitGroup
  def initialize
    @count = 0
    @semaphore = Mutex.new
  end

  def add(delta = 1)
    @count = @count + delta
    raise RuntimeError.new("#{self} has count below 0: you called #done too many times") if @count < 0
    lock
  end

  def done
    add(-1)
  end

  def wait
    lock.value
  end

  private

  def lock
    if @thread && !@thread.alive?
      raise RuntimeError.new("#{self} is being locked after being unlocked.")
    end
    @thread ||= Thread.new do
      @semaphore.lock
      while @count > 0 do
        sleep
      end
      @semaphore.unlock
    end
    @thread.run
  end
end

