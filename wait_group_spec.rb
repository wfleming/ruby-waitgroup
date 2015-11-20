require "minitest/autorun"
require_relative "wait_group"

describe WaitGroup do
  it "works" do
    with_timeout do
      wg = WaitGroup.new
      events = 0

      wg.add(2)

      Thread.new do
        sleep 0.001
        events += 1
        wg.done
      end.run

      Thread.new do
        sleep 0.001
        events += 1
        wg.done
      end.run

      wg.wait
      events.must_equal 2
    end
  end

  it "raises when count is negative" do
    with_timeout do
      wg = WaitGroup.new
      assert_raises(RuntimeError) { wg.done }
    end
  end

  it "raises when you try to reuse an instance" do
    with_timeout do
      wg = WaitGroup.new
      wg.add
      wg.done
      assert_raises(RuntimeError) { wg.add }
    end
  end

  def with_timeout(timeout = 2)
    timed_out = false
    spec_thread = Thread.new do
      Thread.new do
        sleep timeout
        timed_out = true
        spec_thread.kill
      end.run

      yield
    end.run
    sleep 0.1 until !spec_thread.alive?
    refute timed_out, "this spec timed out: this probably indicates a deadlock"
  end
end
