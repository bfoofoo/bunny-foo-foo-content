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
        text: y_title || ""
      }
    }
    series: series || []
  )

init_nested_categories_charts = (element, options) -> 
  Highcharts.chart({
    chart: {
      renderTo: element,
      type: "column"
    },
    title: {
      text: options.topTitle || ""
    },
    series: options.series,
    yAxis: {
      allowDecimals: false,
      title: {
      text: options.yTitle || ""
      }
    },
    xAxis: {
      categories: options.categories || []
    },
    plotOptions: {
        series: {
            pointPadding: 0
        }
    }
  })

$ ->
  $(".highchart").each () ->
    element = $(this)[0]

    series = $(this).data().series
    topTitle = $(this).data().topTitle
    chartType = $(this).data().chartType
    y_title = $(this).data().yTitle

    init_charts(element, series, chartType, y_title, topTitle)

  $(".nested-categories-highchart").each () ->
    element = $(this)[0]

    series = $(this).data().series
    categories = $(this).data().categories
    topTitle = $(this).data().topTitle
    chartType = $(this).data().chartType
    yTitle = $(this).data().yTitle
    init_nested_categories_charts(element, {
      series: series,
      categories: categories,
      yTitle: yTitle
    })