WaitGroup, in Ruby
==================

Quick and dirt implementation of [Go's sync.WaitGroup](https://golang.org/pkg/sync/#WaitGroup).

## Usage

```ruby
class Thing
  def do_work
    @wg = WaitGroup.new

    threaded_work_1
    threaded_work_2

    @wg.wait
    # do something with the results of the threads here
  end

  def threaded_work_1
    @wg.add
    Thread.new do
      begin
        # work goes here
      ensure
        # NOTE: these are put into ensures because in real-life scenarios you
        # might have timeouts killing threads or something, and probably don't
        # want your wait group hanging in these instances. Your usage may not
        # require this.
        @wg.done
      end
    end.run
  end

  def threaded_work_2
    @wg.add
    Thread.new do
      begin
        # other work goes here
      ensure
        @wg.done
      end
    end.run
  end
end
```

