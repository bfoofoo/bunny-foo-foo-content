init_charts = (element, series, chartType, y_title, topTitle) -> 
  new Highcharts.Chart({
      chart: {
          renderTo: element,
          type: "column"
      },
      title: {
        text: "sdsdf"
      },
      series: [{
          name: "Yes",
          data: [4, 14, 4, 5]
      },
      {
          name: "No",
          data: [4, 14, 4, 5]
      },
      {
          name: "B",
          data: [4, 14, 5]
      }
      ],
      yAxis: {
        title: {
          text: "ASDASDASDf"
        }
      },
      xAxis: {
          categories: [
            {	
                colorByPoint: true,
                name: "Q1",
                categories: ["s1", "s2"]
            },
            {
                colorByPoint: true,
                name: "Q2",
                categories: ["s1", "s2"]
            }
          ]
      }
  })

  # Highcharts.chart(element,
  #   chart: {
  #     type: chartType || "column"
  #   },
  #   title: {
  #     text: topTitle 
  #   },
  #   xAxis: {
  #     type: 'category'
  #   },
  #   yAxis: {
  #     allowDecimals: false,
  #     title: {
  #       text: y_title || 'Users Count'
  #     }
  #   }
  #   series: series || []
  # )

$ ->
  $(".highchart").each () ->
    element = $(this)[0]

    series = $(this).data().series
    console.log($(this).data(), '$(this).data()')
    topTitle = $(this).data().topTitle
    chartType = $(this).data().chartType
    y_title = $(this).data().yTitle

    init_charts(element, series, chartType, y_title, topTitle)









# $(function () {

#     var chart = new Highcharts.Chart({
#         chart: {
#             renderTo: "container",
#             type: "column"
#         },
#         title: {
#         	text: "sdsdf"
#         },
#         series: [{
#         		name: "Yes",
#             data: [4, 14, 4, 5]
#         },
#         {
#         		name: "No",
#             data: [4, 14, 4, 5]
#         }
#         ],
#         yAxis: {
#          title: {
#            text: "ASDASDASDf"
#          }
#         },
#         xAxis: {
#             categories: [
#               {	
#                   colorByPoint: true,
#                   name: "Q1",
#                   categories: ["s1", "s2"]
#               },
#               {
#                   colorByPoint: true,
#                   name: "Q2",
#                   categories: ["s1", "s2"]
#               }
#             ]
#         }
#     });
# });