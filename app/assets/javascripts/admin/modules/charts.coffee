init_charts = (element, series, chartType, y_title, topTitle) -> 
  Highcharts.chart(element,
    chart: {
      type: chartType || "column"
    },
    title: {
      text: topTitle 
    },
    xAxis: {
      type: 'category'
    },
    yAxis: {
      allowDecimals: false,
      title: {
        text: y_title || 'Users Count'
      }
    }
    series: series || []
  )

$ ->
  $(".highchart").each () ->
    element = $(this)[0]

    series = $(this).data().series
    topTitle = $(this).data().topTitle
    chartType = $(this).data().chartType
    y_title = $(this).data().yTitle

    init_charts(element, series, chartType, y_title, topTitle)