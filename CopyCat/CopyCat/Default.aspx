<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="CopyCat._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <link href="Content/normalize.css" rel="stylesheet" />
    <link href="Content/ion.rangeSlider.css" rel="stylesheet" />
    <link href="Content/ChartStyles.css" rel="stylesheet" />
    <link href="Content/ion.rangeSlider.skinNice.css" rel="stylesheet" />
    <script>
        var GraphTimeDescriptor = 1 //1 = year 2 = quart 3 = month
        var GraphType = 1 //1 = prec 2 = cooling 3 = temp
        var StateSelection = "Manhattan"
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
        }

        function DrawGraph() {
            UpdateGraph()
            $("#canvas").replaceWith("<canvas id=\"canvas\" height=\"450\" width=\"800\"></canvas>");
            var ctx = document.getElementById("canvas").getContext("2d");
            window.myLine = new Chart(ctx).Line(lineChartData, {});
        }

        function UpdateGraph() {
            var i = 0

            ChartXData = []
            ChartYData = []
            ChartYData2 = []
            ChartYData3 = []

            //for (i = 0; i < OriginalChartXDataYears.length; i++) {
            //    if (OriginalChartXDataYears[i] >= MinimumYear && OriginalChartXDataYears[i] <= MaximumYear) {
            //        ChartXData.push(OriginalChartXDataYears[i])
            //        ChartYData.push(OriginalChartYData[i])
            //        if (OriginalChartYData2.length > 0) {
            //            ChartYData2.push(OriginalChartYData2[i])
            //        }
            //        if (OriginalChartYData3.length > 0) {
            //            ChartYData3.push(OriginalChartYData3[i])
            //        }
            //    }
            //}

            if (GraphTimeDescriptor == 1) {
                var year = new Object()
                for (i = 0; i < OriginalChartXDataYears.length; i++) {
                    if(!year.hasOwnProperty(OriginalChartXDataYears[i])){
                        year[OriginalChartXDataYears[i]] = []
                    }
                    year[OriginalChartXDataYears[i]].push(OriginalChartYData[i])
                }

                for (var propt in year) {
                    ChartXData.push(propt)

                    var yearAverage = 0
                    var valueCount = 0
                    for (var value in year[propt]) {
                        yearAverage += year[propt][value]
                        valueCount += 1
                    }
                    yearAverage = yearAverage / valueCount

                    ChartYData.push(yearAverage)
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
                            fillColor: "rgba(151,187,205,0.2)",
                            strokeColor: "rgba(151,187,205,1)",
                            pointColor: "rgba(151,187,205,1)",
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
                            fillColor: "rgba(151,187,205,0.2)",
                            strokeColor: "rgba(151,187,205,1)",
                            pointColor: "rgba(151,187,205,1)",
                            pointStrokeColor: "#fff",
                            pointHighlightFill: "#fff",
                            pointHighlightStroke: "rgba(151,187,205,1)",
                            data: ChartYData2
                        },
                        {
                            label: "My Second dataset",
                            fillColor: "rgba(151,187,205,0.2)",
                            strokeColor: "rgba(151,187,205,1)",
                            pointColor: "rgba(151,187,205,1)",
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
            var str = "{ \"Years\": [1990, 1990, 1990, 1990, 1991, 1991, 1992, 1993], \"Months\": [1, 2, 4, 5, 5,6,7,8], \"Precipitation\": [1, 2, 4, 5, 1, 2, 3,4] }"
            var arr = JSON.parse(result);
            var i;

            OriginalChartXDataYears = []
            OriginalChartXDataMonths = []
            OriginalChartYData = []

            for (i = 0; i < arr.Years.length; i++) {
                OriginalChartXDataYears.push(arr.Years[i])
                OriginalChartXDataMonths.push(arr.Months[i])
                OriginalChartYData.push(arr.Precipitation[i])                              
            }           

            DrawGraph()
        }

        function CoolingHeatingSuccess(result) {
            
            DrawGraph()
        }

        function TemperatureSuccess(result) {
           
            DrawGraph()
        }

        function Failure(error) {
            alert(error);
        }
	</script>

    <!------------------------- Initial Form ------->
    
    <div id="dbFormArea" runat="server">
        <div>  
            <asp:Button ID="Button1" runat="server" Text="Get Name" OnClientClick='GetName();return false;' />
        </div>
        <div id="dbForm" runat="server">
            <div class="row">
                <div class="col-md-12">
                    <h1><span style="font-size: large">Local DB</span></h1>
                    <hr />
                </div>
            </div>
            <div class="row">
                <div class="col-md-2">
                    <asp:FileUpload ID="FileUploadControl" runat="server" />
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
                    <asp:Button runat="server" ID="UploadButton" Text="Upload" OnClick="UploadButton_Click" />
                </div>
                <div class="col-md-9">
                    <asp:Label runat="server" ID="StatusLabel" Text="Upload status: " />
                </div>
            </div>

        </div>

    </div>

    <br />

    <div class="row">
        <div class="col-md-4">
            <div class="dropdown">
                <button class="btn btn-default dropdown-toggle" type="button" id="GraphSelection" data-toggle="dropdown" aria-expanded="true">
                Graphs
                <span class="caret"></span>
                </button>
                <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenuGraphSelection">
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
            <div class="dropdown">
                <button class="btn btn-default dropdown-toggle" type="button" id="AreaSelection" data-toggle="dropdown" aria-expanded="true">
                Area Selection
                <span class="caret"></span>
                </button>
                <ul class="dropdown-menu scrollable-menu" role="menu" aria-labelledby="dropdownMenuGraphSelection">
                    <li role="presentation"><a role="menuitem" tabindex="-1" href="#" onclick="StateSelection='New York'">Precipitation</a></li>
                    <li role="presentation"><a role="menuitem" tabindex="-1" href="javascript:CoolingHeatingGraph();">Cooling days/Heating days</a></li>
                    <li role="presentation"><a role="menuitem" tabindex="-1" href="javascript:TemperatureGraph();">Temperature</a></li>
                    <li role="presentation"><a role="menuitem" tabindex="-1" href="javascript:CoolingHeatingGraph();">Cooling days/Heating days</a></li>
                    <li role="presentation"><a role="menuitem" tabindex="-1" href="javascript:TemperatureGraph();">Temperature</a></li>
                    <li role="presentation"><a role="menuitem" tabindex="-1" href="javascript:CoolingHeatingGraph();">Cooling days/Heating days</a></li>
                    <li role="presentation"><a role="menuitem" tabindex="-1" href="javascript:CoolingHeatingGraph();">Cooling days/Heating days</a></li>
                    <li role="presentation"><a role="menuitem" tabindex="-1" href="javascript:CoolingHeatingGraph();">Cooling days/Heating days</a></li>
                    <li role="presentation"><a role="menuitem" tabindex="-1" href="javascript:CoolingHeatingGraph();">Cooling days/Heating days</a></li>
                    <li role="presentation"><a role="menuitem" tabindex="-1" href="javascript:CoolingHeatingGraph();">Cooling days/Heating days</a></li>
                    <li role="presentation"><a role="menuitem" tabindex="-1" href="javascript:CoolingHeatingGraph();">Cooling days/Heating days</a></li>
                    <li role="presentation"><a role="menuitem" tabindex="-1" href="javascript:CoolingHeatingGraph();">Cooling days/Heating days</a></li>
                    <li role="presentation"><a role="menuitem" tabindex="-1" href="javascript:CoolingHeatingGraph();">Cooling days/Heating days</a></li>
                    <li role="presentation"><a role="menuitem" tabindex="-1" href="javascript:CoolingHeatingGraph();">Cooling days/Heating days</a></li>
                    <li role="presentation"><a role="menuitem" tabindex="-1" href="javascript:TemperatureGraph();">Temperature</a></li>
                    <li role="presentation"><a role="menuitem" tabindex="-1" href="javascript:TemperatureGraph();">Temperature</a></li>
                    <li role="presentation"><a role="menuitem" tabindex="-1" href="javascript:TemperatureGraph();">Temperature</a></li>
                    <li role="presentation"><a role="menuitem" tabindex="-1" href="javascript:TemperatureGraph();">Temperature</a></li>
                    <li role="presentation"><a role="menuitem" tabindex="-1" href="javascript:TemperatureGraph();">Temperature</a></li>
                    <li role="presentation"><a role="menuitem" tabindex="-1" href="javascript:TemperatureGraph();">Temperature</a></li>
                    <li role="presentation"><a role="menuitem" tabindex="-1" href="javascript:TemperatureGraph();">Temperature</a></li>
                    <li role="presentation"><a role="menuitem" tabindex="-1" href="javascript:TemperatureGraph();">Temperature</a></li>
                    <li role="presentation"><a role="menuitem" tabindex="-1" href="javascript:TemperatureGraph();">Temperature</a></li>
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

</asp:Content>
