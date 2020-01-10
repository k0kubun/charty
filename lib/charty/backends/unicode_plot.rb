require 'stringio'

module Charty
  module Backends
    class UnicodePlot
      Backends.register(:unicode_plot, self)

      class << self
        def prepare
          require 'unicode_plot'
        end
      end

      def begin_figure
        @figure = nil
        @layout = {}
      end

      def bar(bar_pos, values, color: nil)
        @figure = {
          type: :bar,
          bar_pos: bar_pos,
          values: values
        }
      end

      def box_plot(plot_data, positions, color:, gray:)
        @figure = { type: :box, data: plot_data }
      end

      def set_xlabel(label)
        @layout[:xlabel] = label
      end

      def set_ylabel(label)
        @layout[:ylabel] = label
      end

      def set_xticks(values)
        @layout[:xticks] = values
      end

      def set_xtick_labels(values)
        @layout[:xtick_labels] = values
      end

      def set_xlim(min, max)
        @layout[:xlim] = [min, max]
      end

      def disable_xaxis_grid
        # do nothing
      end

      def show
        case @figure[:type]
        when :bar
          plot = ::UnicodePlot.barplot(@layout[:xtick_labels], @figure[:values], xlabel: @layout[:xlabel])
        when :box
          plot = ::UnicodePlot.boxplot(@layout[:xtick_labels], @figure[:data], xlabel: @layout[:xlabel])
        end
        sio = StringIO.new
        class << sio
          def tty?; true; end
        end
        plot.render(sio)
        sio.string
      end

      private

      def show_bar(sio, figure, i)
      end

      def show_box(sio, figure, i)
      end
    end
  end
end
