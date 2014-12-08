<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="CopyCat._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <link href="Content/normalize.css" rel="stylesheet" />
    <link href="Content/ion.rangeSlider.css" rel="stylesheet" />
    <link href="Content/ChartStyles.css" rel="stylesheet" />
    <link href="Content/ion.rangeSlider.skinNice.css" rel="stylesheet" />
    <script>
        var GraphTimeDescriptor = 1 //1 = year 2 = quart 3 = month
        var GraphType = 1 //1 = prec 2 = cooling 3 = temp
        var StateSelection = 1;
        var MinimumYear = 1990
        var MaximumYear = 2015
        var Months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ]

        var OriginalChartXDataYears = []
        var OriginalChartXDataMonths = []
        var OriginalChartYData = []
        var OriginalChartYData2 = []
        var OriginalChartYData3 = []

        var ChartXData = []
        var ChartYData = []
        var ChartYData2 = []
        var ChartYData3 = []
       
        var lineChartData = {
            labels: ChartXData,
            datasets: [
				{
				    label: "My Second dataset",
				    fillColor: "rgba(151,187,205,0.2)",
				    strokeColor: "rgba(151,187,205,1)",
				    pointColor: "rgba(151,187,205,1)",
				    pointStrokeColor: "#fff",
				    pointHighlightFill: "#fff",
				    pointHighlightStroke: "rgba(151,187,205,1)",
				    data: ChartYData
				}
            ]
        }

        window.onload = function () {
            var ctx = document.getElementById("canvas").getContext("2d");
            window.myLine = new Chart(ctx).Line(lineChartData, {
            });
            $("#spinner").hide();
        }

        function DrawGraph() {
            UpdateGraph()
            $("#canvas").replaceWith("<canvas id=\"canvas\" height=\"450\" width=\"800\"></canvas>");
            var ctx = document.getElementById("canvas").getContext("2d");
            window.myLine = new Chart(ctx).Line(lineChartData, {});
        }

        

        $(function () {

            $(".graphSelection li a").click(function () {

                $(".graphSelectionBtn").html($(this).text() + " <span class=\"caret\"></span>");
                $(".graphSelectionBtn").val($(this).text() + " <span class=\"caret\"></span>");
            });

        });

        $(function () {

            $(".areaSelection li a").click(function () {

                $(".AreaSelection").html($(this).text() + " <span class=\"caret\"></span>");
                $(".AreaSelection").val($(this).text() + " <span class=\"caret\"></span>");
            });

        });

        function UpdateGraph() {
            var i = 0

            ChartXData = []
            ChartYData = []
            ChartYData2 = []
            ChartYData3 = []

            if (GraphTimeDescriptor == 1) {
                var year = new Object()
                for (i = 0; i < OriginalChartXDataYears.length; i++) {
                    if(!year.hasOwnProperty(OriginalChartXDataYears[i])){
                        year[OriginalChartXDataYears[i]] = []
                        if (OriginalChartYData2.length > 0) {
                            year[OriginalChartXDataYears[i] + "/2"] = []
                        }
                        if (OriginalChartYData3.length > 0) {
                            year[OriginalChartXDataYears[i] + "/3"] = []
                        }
                    }
                    year[OriginalChartXDataYears[i]].push(OriginalChartYData[i])

                    if (OriginalChartYData2.length > 0) {
                        year[OriginalChartXDataYears[i] + "/2"].push(OriginalChartYData2[i])
                    }
                    if (OriginalChartYData3.length > 0) {
                        year[OriginalChartXDataYears[i] + "/3"].push(OriginalChartYData3[i])
                    }
                };

                for (var propt in year) {
                    var yearAverage = 0
                    var valueCount = 0

                    if (propt.indexOf("/2") > -1) {
                        for (var value in year[propt]) {
                            yearAverage += parseInt(year[propt][value])
                            valueCount += 1
                        }
                        yearAverage = yearAverage / valueCount

                        ChartYData2.push(yearAverage)
                    }
                    else if (propt.indexOf("/3") > -1) {
                        for (var value in year[propt]) {
                            yearAverage += parseInt(year[propt][value])
                            valueCount += 1
                        }
                        yearAverage = yearAverage / valueCount

                        ChartYData3.push(yearAverage)
                    }
                    else {
                        ChartXData.push(propt)
                       
                        for (var value in year[propt]) {
                            yearAverage += parseInt(year[propt][value])
                            valueCount += 1
                        }
                        yearAverage = yearAverage / valueCount

                        ChartYData.push(yearAverage)
                    }                    
                }

                for (i = 0; i < year.length; i++) {
                    ChartXData.push(OriginalChartXDataYears[i] + "-" + Months[OriginalChartXDataMonths[i] - 1])
                    ChartYData.push(OriginalChartYData[i])
                    if (OriginalChartYData2.length > 0) {
                        ChartYData2.push(OriginalChartYData2[i])
                    }
                    if (OriginalChartYData3.length > 0) {
                        ChartYData3.push(OriginalChartYData3[i])
                    }
                }
            }

            if (GraphTimeDescriptor == 2) {
                var year = new Object()
                for (i = 0; i < OriginalChartXDataYears.length; i++) {
                    if (!year.hasOwnProperty(OriginalChartXDataYears[i])) {
                        year[OriginalChartXDataYears[i]] = []
                        if (OriginalChartYData2.length > 0) {
                            year[OriginalChartXDataYears[i] + "/2"] = []
                        }
                        if (OriginalChartYData3.length > 0) {
                            year[OriginalChartXDataYears[i] + "/3"] = []
                        }
                    }
                    year[OriginalChartXDataYears[i]].push(OriginalChartYData[i])

                    if (OriginalChartYData2.length > 0) {
                        year[OriginalChartXDataYears[i] + "/2"].push(OriginalChartYData2[i])
                    }
                    if (OriginalChartYData3.length > 0) {
                        year[OriginalChartXDataYears[i] + "/3"].push(OriginalChartYData3[i])
                    }
                };

                for (var propt in year) {
                    var yearAverage = 0
                    var valueCount = 0

                    if (propt.indexOf("/2") > -1) {
                        
                    }
                    else if (propt.indexOf("/3") > -1) {
                        
                    }
                    else {
                       
                    }
                }

            }

            if (GraphTimeDescriptor == 3) {
                for (i = 0; i < OriginalChartXDataYears.length; i++) {                    
                    ChartXData.push(OriginalChartXDataYears[i] + "-" + Months[OriginalChartXDataMonths[i]-1])
                    ChartYData.push(OriginalChartYData[i])
                    if (OriginalChartYData2.length > 0) {
                        ChartYData2.push(OriginalChartYData2[i])
                    }
                    if (OriginalChartYData3.length > 0) {
                        ChartYData3.push(OriginalChartYData3[i])
                    }                    
                }
            }
            
            if (GraphType == 1) {
                lineChartData = {
                    labels: ChartXData,
                    datasets: [
                        {
                            label: "My Second dataset",
                            fillColor: "rgba(151,187,205,0.2)",
                            strokeColor: "rgba(151,187,205,1)",
                            pointColor: "rgba(151,187,205,1)",
                            pointStrokeColor: "#fff",
                            pointHighlightFill: "#fff",
                            pointHighlightStroke: "rgba(151,187,205,1)",
                            data: ChartYData
                        }
                    ]
                }
            }
            if (GraphType == 2) {
                lineChartData = {
                    labels: ChartXData,
                    datasets: [
                        {
                            label: "My Second dataset",
                            fillColor: "rgba(151,187,205,0.2)",
                            strokeColor: "rgba(151,187,205,1)",
                            pointColor: "rgba(151,187,205,1)",
                            pointStrokeColor: "#fff",
                            pointHighlightFill: "#fff",
                            pointHighlightStroke: "rgba(151,187,205,1)",
                            data: ChartYData
                        },
                        {
                            label: "My Second dataset",
                            fillColor: "rgba(200,0,0,0.2)",
                            strokeColor: "rgba(200,0,0,1)",
                            pointColor: "rgba(200,0,0,1)",
                            pointStrokeColor: "#fff",
                            pointHighlightFill: "#fff",
                            pointHighlightStroke: "rgba(151,187,205,1)",
                            data: ChartYData2
                        }
                    ]
                }
            }
            if (GraphType == 3) {
                lineChartData = {
                    labels: ChartXData,
                    datasets: [
                        {
                            label: "My Second dataset",
                            fillColor: "rgba(151,187,205,0.2)",
                            strokeColor: "rgba(151,187,205,1)",
                            pointColor: "rgba(151,187,205,1)",
                            pointStrokeColor: "#fff",
                            pointHighlightFill: "#fff",
                            pointHighlightStroke: "rgba(151,187,205,1)",
                            data: ChartYData
                        },
                        {
                            label: "My Second dataset",
                            fillColor: "rgba(200,0,0,0.2)",
                            strokeColor: "rgba(200,0,0,1)",
                            pointColor: "rgba(200,0,0,1)",
                            pointStrokeColor: "#fff",
                            pointHighlightFill: "#fff",
                            pointHighlightStroke: "rgba(151,187,205,1)",
                            data: ChartYData2
                        },
                        {
                            label: "My Second dataset",
                            fillColor: "rgba(0,200,0,0.2)",
                            strokeColor: "rgba(0,200,0,1)",
                            pointColor: "rgba(0,200,0,1)",
                            pointStrokeColor: "#fff",
                            pointHighlightFill: "#fff",
                            pointHighlightStroke: "rgba(151,187,205,1)",
                            data: ChartYData3
                        }
                    ]
                }
            }            
        }

        function PrecipitationGraph() {
            GraphType = 1
            PageMethods.GetPrecipitationData(StateSelection, PrecipitationSuccess, Failure);
        }
        function CoolingHeatingGraph() {
            GraphType = 2
            PageMethods.GetCoolingHeatingDaysData(StateSelection, CoolingHeatingSuccess, Failure);
        }
        function TemperatureGraph() {
            GraphType = 3
            PageMethods.GetTemperatureData(StateSelection, TemperatureSuccess, Failure);
        }
       
        function PrecipitationSuccess(result) {  
            var arr = JSON.parse(result);
            var i;

            OriginalChartXDataYears = []
            OriginalChartXDataMonths = []
            OriginalChartYData = []

            for (i = 0; i < arr.year.length; i++) {
                OriginalChartXDataYears.push(arr.year[i])
                OriginalChartXDataMonths.push(arr.month[i])
                OriginalChartYData.push(arr.pcp[i])                              
            }           

            DrawGraph()
        }

        function CoolingHeatingSuccess(result) {
            var arr = JSON.parse(result);
            var i;

            OriginalChartXDataYears = []
            OriginalChartXDataMonths = []
            OriginalChartYData = []
            OriginalChartYData2 = []

            for (i = 0; i < arr.year.length; i++) {
                OriginalChartXDataYears.push(arr.year[i])
                OriginalChartXDataMonths.push(arr.month[i])
                OriginalChartYData.push(arr.cdd[i])
                OriginalChartYData2.push(arr.hdd[i])
            }

            DrawGraph()
        }

        function TemperatureSuccess(result) {
            var arr = JSON.parse(result);
            var i;

            OriginalChartXDataYears = []
            OriginalChartXDataMonths = []
            OriginalChartYData = []
            OriginalChartYData2 = []
            OriginalChartYData3 = []

            for (i = 0; i < arr.year.length; i++) {
                OriginalChartXDataYears.push(arr.year[i])
                OriginalChartXDataMonths.push(arr.month[i])
                OriginalChartYData.push(arr.tmin[i])
                OriginalChartYData2.push(arr.tmax[i])
                OriginalChartYData3.push(arr.tavg[i])
            }

            DrawGraph()
        }

        function Failure(error) {
            alert(error);
        }
	</script>

    <!------------------------- Initial Form ------->

    <br />

    <br />

    <div class="row">
        <div class="col-md-4">
            <label>Graph Type: </label>
            <br/>    
            <div class="dropdown">
                <button class="btn btn-default graphSelectionBtn dropdown-toggle" type="button" id="GraphSelection" data-toggle="dropdown" aria-expanded="true">
                Graphs
                <span class="caret"></span>
                </button>
                <ul class="dropdown-menu graphSelection" role="menu" aria-labelledby="dropdownMenuGraphSelection">
                    <li role="presentation"><a role="menuitem" tabindex="-1" href="javascript:PrecipitationGraph();">Precipitation</a></li>
                    <li role="presentation"><a role="menuitem" tabindex="-1" href="javascript:CoolingHeatingGraph();">Cooling days/Heating days</a></li>
                    <li role="presentation"><a role="menuitem" tabindex="-1" href="javascript:TemperatureGraph();">Temperature</a></li>
                </ul>
            </div>
        </div>
        <div class="col-md-4">
            <div class="btn-group" role="group" aria-label="...">
              <button type="button" class="btn btn-default" onclick="GraphTimeDescriptor='1';DrawGraph()">Yearly</button>
              <button type="button" class="btn btn-default" onclick="GraphTimeDescriptor='2';DrawGraph()">Quarterly</button>
              <button type="button" class="btn btn-default" onclick="GraphTimeDescriptor='3';DrawGraph()">Monthly</button>
            </div>
        </div>
        <div class="col-md-4"> 
            <label>Area: </label>
            <br />       
            <div class="dropdown">
                <button class="btn btn-default  AreaSelection dropdown-toggle" type="button" id="AreaSelection" runat="Server" data-toggle="dropdown" aria-expanded="true">
                Alabama
                <span class="caret"></span>
                </button>
                <ul class="dropdown-menu areaSelection scrollable-menu" role="menu" runat="server" id="stateDropDown">
                    
                </ul>
            </div>
        </div>
    </div>

    <div class="jumbotron">
		<div>
			<canvas id="canvas" height="450" width="800"></canvas>
			<br />
			<input type="text" id="example_id" name="example_name" value="" />
			<label id="leftVal"></label><label id="rightVal"></label>
            <script>
                $("#example_id").ionRangeSlider({
                    type: "double",
                    grid: true,
                    min: 1990,
                    max: 2015,
                    from: 200,
                    to: 800
                });

                $("#example_id").on("change", function () {
                    var $this = $(this),
						value = $this.prop("value");

                    var res = value.split(";")
                    MinimumYear = res[0]
                    MaximumYear = res[1]

                    var maxYear = Math.max.apply(Math, OriginalChartXDataYears);
                    var minYear = Math.min.apply(Math, OriginalChartXDataYears);

                    if(minYear <= MinimumYear && minYear <= MaximumYear && maxYear >= MinimumYear && maxYear <= MaximumYear){
                        DrawGraph()
                    }

                    //if (MinimumYear >= minYear && MinimumYear <= maxYear && MaximumYear >= minYear && MaximumYear <= maxYear) 
                    
                });
			</script>
		</div>
    </div>

    <div id="dbFormArea" runat="server">
        <div id="dbForm" runat="server">
            <div class="row">
                <div class="col-md-12">
                    <h1><span style="font-size: large">Upload Data</span></h1>
                    <hr />
                </div>
            </div>
            <div class="row">
                <div class="col-md-2">
                    <asp:FileUpload class="btn btn-default" ID="FileUploadControl" runat="server" />
                </div>
                <div class="col-md-4">
                    
                </div>
                <div class="col-md-6">
                </div>
            </div>
            <br />
            <br />
            <div class="row">                
                <div class="col-md-3">
                    <asp:Button runat="server" class="btn uploadBTN btn-default" ID="UploadButton" Text="Upload" OnClick="UploadButton_Click" />
                </div>
                <div class="col-md-2">
                    <asp:Label runat="server"  ID="StatusLabel" Text="Upload status: " />
                </div>
                <div class="col-md-1">
                    <div class="spinnerDiv" id="spinner" runat="server" ></div>
                </div>
            </div>

        </div>

    </div>
    <script>
        var opts = {
            lines: 17, // The number of lines to draw
            length: 14, // The length of each line
            width: 10, // The line thickness
            radius: 0, // The radius of the inner circle
            corners: 1, // Corner roundness (0..1)
            rotate: 0, // The rotation offset
            direction: 1, // 1: clockwise, -1: counterclockwise
            color: '#000', // #rgb or #rrggbb or array of colors
            speed: 1, // Rounds per second
            trail: 60, // Afterglow percentage
            shadow: false, // Whether to render a shadow
            hwaccel: false, // Whether to use hardware acceleration
            className: 'spinner', // The CSS class to assign to the spinner
            zIndex: 2e9, // The z-index (defaults to 2000000000)
            top: '50%', // Top position relative to parent
            left: '50%' // Left position relative to parent
        };
        var target = document.getElementById('spinner');
        var spinner = new Spinner(opts).spin(target);
        $(".uploadBTN").click(function () {
            $(".spinnerDiv").show();
            $(".uploadBTN").disabled = true;
        });
    </script>
</asp:Content>
