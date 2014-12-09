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

        var ScrollBarMinimumYear = 1990
        var ScrollBarMaximumYear = 2015
        
        var minGraphYear = 1990
        var maxGraphYear = 2200

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
            GenerateGraph()
            $("#canvas").replaceWith("<canvas id=\"canvas\" height=\"450\" width=\"1000\"></canvas>");
            var ctx = document.getElementById("canvas").getContext("2d");
            window.myLine = new Chart(ctx).Line(lineChartData, {legendTemplate: "<ul class=\"legend\"><li><span>Charlie</span></li><li><span>Choco</span></li></ul>"});
            //document.getElementById("legendDiv").innerHTML = window.myLine.generateLegend();
            legend(document.getElementById("legendDiv"), lineChartData);
            
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

        function SetOriginalData() {
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

            return year
        }

        function GenerateGraph() {           

            var i = 0

            ChartXData = []
            ChartYData = []
            ChartYData2 = []
            ChartYData3 = []

            if (GraphTimeDescriptor == 1) {
                var year = SetOriginalData()

                for (var propt in year) {
                    var yearAverage = 0
                    var valueCount = 0

                    if (propt.indexOf("/2") > -1) {
                        for (var value in year[propt]) {
                            yearAverage += parseFloat(year[propt][value])
                            valueCount += 1
                        }
                        yearAverage = yearAverage / valueCount

                        ChartYData2.push(yearAverage)
                    }
                    else if (propt.indexOf("/3") > -1) {
                        for (var value in year[propt]) {
                            yearAverage += parseFloat(year[propt][value])
                            valueCount += 1
                        }
                        yearAverage = yearAverage / valueCount

                        ChartYData3.push(yearAverage)
                    }
                    else {
                        ChartXData.push(propt)
                       
                        for (var value in year[propt]) {
                            yearAverage += parseFloat(year[propt][value])
                            valueCount += 1
                        }
                        yearAverage = yearAverage / valueCount

                        ChartYData.push(yearAverage)
                    }                    
                }           
            }

            if (GraphTimeDescriptor == 2) {
                var year = SetOriginalData()

                for (var propt in year) {                        
                    var q1 = (parseFloat(year[propt][0]) + parseFloat(year[propt][1]) + parseFloat(year[propt][2])) / 3
                    var q2 = (parseFloat(year[propt][3]) + parseFloat(year[propt][4]) + parseFloat(year[propt][5])) / 3
                    var q3 = (parseFloat(year[propt][6]) + parseFloat(year[propt][7]) + parseFloat(year[propt][8])) / 3
                    var q4 = (parseFloat(year[propt][9]) + parseFloat(year[propt][10]) + parseFloat(year[propt][11])) / 3

                    if (propt.indexOf("/2") > -1) {
                        if (!isNaN(q1)) { ChartYData2.push(q1) }
                        if (!isNaN(q2)) { ChartYData2.push(q2) }
                        if (!isNaN(q3)) { ChartYData2.push(q3) }
                        if (!isNaN(q4)) { ChartYData2.push(q4) }
                    }
                    else if (propt.indexOf("/3") > -1) {
                        if (!isNaN(q1)) { ChartYData3.push(q1) }
                        if (!isNaN(q2)) { ChartYData3.push(q2) }
                        if (!isNaN(q3)) { ChartYData3.push(q3) }
                        if (!isNaN(q4)) { ChartYData3.push(q4) }
                    }
                    else {      
                        if (!isNaN(q1)) { ChartXData.push(propt + " Q1"); ChartYData.push(q1) }
                        if (!isNaN(q2)) { ChartXData.push("Q2"); ChartYData.push(q2) }
                        if (!isNaN(q3)) { ChartXData.push("Q3"); ChartYData.push(q3) }
                        if (!isNaN(q4)) { ChartXData.push("Q4"); ChartYData.push(q4) }                   
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
            
            var tempXData = []
            var tempYData = []
            var tempYData2 = []
            var tempYData3 = []

            for (var i = 0; i < ChartXData.length; i++) {
                var currentYear = parseInt(ChartXData[i].substring(0, 4))
                var quarter = ChartXData[i].indexOf("Q")

                if (currentYear >= ScrollBarMinimumYear && currentYear <= ScrollBarMaximumYear) {
                    if ((ScrollBarMaximumYear - ScrollBarMinimumYear) > 5 && GraphTimeDescriptor == 3) {
                        if (ChartXData[i].indexOf("January") > -1) {
                            tempXData.push(ChartXData[i])
                        }
                        else {
                            tempXData.push("")
                        }                                            
                    }                    
                    else {
                        tempXData.push(ChartXData[i])
                    }
                    
                    tempYData.push(ChartYData[i])

                    if (ChartYData2.length > 0) {
                        tempYData2.push(ChartYData2[i])
                    }                    
                    if (ChartYData3.length > 0) {
                        tempYData3.push(ChartYData3[i])
                    }

                    if (quarter > -1) {
                        if ((ScrollBarMaximumYear - ScrollBarMinimumYear) > 15 && GraphTimeDescriptor == 2) {
                            if (ChartXData[i].indexOf("Q1") > -1) {
                                tempXData.push(ChartXData[i])
                            }
                            else {
                                tempXData.push("")
                                tempXData.push("")
                                tempXData.push("")
                            }
                        }
                        else {
                            tempXData.push(ChartXData[i + 1])
                            tempXData.push(ChartXData[i + 2])
                            tempXData.push(ChartXData[i + 3])
                        }                        

                        tempYData.push(ChartYData[i + 1])
                        tempYData.push(ChartYData[i + 2])
                        tempYData.push(ChartYData[i + 3])

                        if (ChartYData2.length > 0) {
                            tempYData2.push(ChartYData2[i + 1])
                            tempYData2.push(ChartYData2[i + 2])
                            tempYData2.push(ChartYData2[i + 3])
                        }
                        if (ChartYData3.length > 0) {
                            tempYData3.push(ChartYData3[i + 1])
                            tempYData3.push(ChartYData3[i + 2])
                            tempYData3.push(ChartYData3[i + 3])
                        }

                        i += 3
                    }
                }                
            }

            ChartXData = tempXData
            ChartYData = tempYData
            ChartYData2 = tempYData2
            ChartYData3 = tempYData3

            lineChartData = {
                labels: ChartXData,
                datasets: [
                    {
                        label: "Precipitation",
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
            if (GraphType == 2) {
                lineChartData["datasets"][0].label = "Cooling Days"
                lineChartData["datasets"].push({
                    label: "Heating Days",
                    fillColor: "rgba(200,0,0,0.2)",
                    strokeColor: "rgba(200,0,0,1)",
                    pointColor: "rgba(200,0,0,1)",
                    pointStrokeColor: "#fff",
                    pointHighlightFill: "#fff",
                    pointHighlightStroke: "rgba(151,187,205,1)",
                    data: ChartYData2
                })
            }
            if (GraphType == 3) {
                lineChartData["datasets"][0].label = "Minimum Temperature"                
                lineChartData["datasets"].push({
                    label: "Maximum Temperature",
                    fillColor: "rgba(200,0,0,0.2)",
                    strokeColor: "rgba(200,0,0,1)",
                    pointColor: "rgba(200,0,0,1)",
                    pointStrokeColor: "#fff",
                    pointHighlightFill: "#fff",
                    pointHighlightStroke: "rgba(151,187,205,1)",
                    data: ChartYData2
                })          
                lineChartData["datasets"].push({
                    label: "Average Temperature",
                    fillColor: "rgba(0,200,0,0.2)",
                    strokeColor: "rgba(0,200,0,1)",
                    pointColor: "rgba(0,200,0,1)",
                    pointStrokeColor: "#fff",
                    pointHighlightFill: "#fff",
                    pointHighlightStroke: "rgba(151,187,205,1)",
                    data: ChartYData3
                })               
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

        function ClearOriginalData() {
            OriginalChartXDataYears = []
            OriginalChartXDataMonths = []
            OriginalChartYData = []
            OriginalChartYData2 = []
            OriginalChartYData3 = []
        }

        function PrecipitationSuccess(result) {  
            var arr = JSON.parse(result);
            var i;
            
            ClearOriginalData()

            for (i = 0; i < arr.year.length; i++) {
                OriginalChartXDataYears.push(arr.year[i])
                OriginalChartXDataMonths.push(arr.month[i])
                OriginalChartYData.push(arr.pcp[i])                              
            }

            UpdateSlider()

            DrawGraph()
        }

        function CoolingHeatingSuccess(result) {
            var arr = JSON.parse(result);
            var i;

            ClearOriginalData()

            for (i = 0; i < arr.year.length; i++) {
                OriginalChartXDataYears.push(arr.year[i])
                OriginalChartXDataMonths.push(arr.month[i])
                OriginalChartYData.push(arr.cdd[i])
                OriginalChartYData2.push(arr.hdd[i])
            }
            UpdateSlider()

            DrawGraph()
        }

        function TemperatureSuccess(result) {
            var arr = JSON.parse(result);
            var i;

            ClearOriginalData()

            for (i = 0; i < arr.year.length; i++) {
                OriginalChartXDataYears.push(arr.year[i])
                OriginalChartXDataMonths.push(arr.month[i])
                OriginalChartYData.push(arr.tmin[i])
                OriginalChartYData2.push(arr.tmax[i])
                OriginalChartYData3.push(arr.tavg[i])
            }

            UpdateSlider()

            DrawGraph()
        }

        function Failure(error) {
            alert(error);
        }

        function UpdateSlider() {         
            var slider = $("#XValueSlider").data("ionRangeSlider");

            // Call sliders update method with any params
            slider.update({
                type: "double",
                grid: true,
                min: minGraphYear,
                max: maxGraphYear,
                from: minGraphYear,
                to: maxGraphYear
            });
        }

        function UpdateSlider() {
            maxGraphYear = Math.max.apply(Math, OriginalChartXDataYears);
            minGraphYear = Math.min.apply(Math, OriginalChartXDataYears);

            ScrollBarMinimumYear = minGraphYear
            ScrollBarMaximumYear = maxGraphYear

            var slider = $("#XValueSlider").data("ionRangeSlider")
            slider.destroy()
            // Call sliders update method with any params
            $("#XValueSlider").ionRangeSlider({
                type: "double",
                grid: true,
                min: minGraphYear,
                max: maxGraphYear,
                from: minGraphYear,
                to: maxGraphYear
            });
        }

        function legend(parent, data) {
            parent.className = 'legend';
            var datas = data.hasOwnProperty('datasets') ? data.datasets : data;

            // remove possible children of the parent
            while (parent.hasChildNodes()) {
                parent.removeChild(parent.lastChild);
            }

            datas.forEach(function (d) {
                var title = document.createElement('span');
                title.className = 'title';
                title.style.borderColor = d.hasOwnProperty('strokeColor') ? d.strokeColor : d.color;
                title.style.borderStyle = 'solid';
                parent.appendChild(title);

                var text = document.createTextNode(d.label);
                title.appendChild(text);
            });
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
			<canvas id="canvas" height="450" width="1000"></canvas>
            <div id="legendDiv"></div>            

			<br />
			<input type="text" id="XValueSlider" name="XValueSlider" value="" />
			<label id="leftVal"></label><label id="rightVal"></label>
            <script>
                $("#XValueSlider").ionRangeSlider({
                    type: "double",
                    grid: true,
                    min: minGraphYear,
                    max: maxGraphYear,
                    from: minGraphYear,
                    to: maxGraphYear
                });


                $("#XValueSlider").on("change", function () {
                    var $this = $(this),
						value = $this.prop("value");

                    var res = value.split(";")
                    ScrollBarMinimumYear = res[0]
                    ScrollBarMaximumYear = res[1]                    

                    //if (ScrollBarMinimumYear >= minGraphYear && ScrollBarMinimumYear <= maxGraphYear || ScrollBarMaximumYear >= minGraphYear && ScrollBarMaximumYear <= maxGraphYear) {
                        DrawGraph()
                    //}
                    
                });
			</script>
		</div>
    </div>

   <div class="row"> 
       <div class="col-md-4">
       </div>
       <div class="col-md-4">
           <A class="btn btn-default" HREF="javascript:window.print()">Click to Print This Page</A> 
       </div>
       <div class="col-md-4">
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
                    <div id="uploadDiv" >
                        <input type="button" value="Upload" class="btn uploadBTN btn-default"/>
                    </div>

                    <div id="confirmUploadDiv" class="well" style="display:none;">
                        Are you sure you want to upload? This will overwrite all data stored.                        
                        <asp:Button class="btn yesBtn btn-default" runat="server" Text="Yes" ID="yesBtn" OnClick="UploadButton_Click"></asp:Button>   
                        <input type="button" value="No" class="btn noBtn btn-default" ID="noBtn"/>
                    </div>                 
                </div>
                <div class="col-md-2">
                    <asp:Label runat="server"  ID="StatusLabel" Text="Upload status: " />
                </div>
                <div class="col-md-1" id="spinnerDiv">
                </div>
            </div>

        </div>

    </div>
    <script>        
        $(".uploadBTN").click(function () {
            document.getElementById('confirmUploadDiv').style.display = "block";
            document.getElementById('uploadDiv').style.display = "none";
        });

        $(".noBtn").click(function () {
            document.getElementById('confirmUploadDiv').style.display = "none";
            document.getElementById('uploadDiv').style.display = "block";
        });

        $(".yesBtn").click(function () {
            var opts = {
                lines: 13, // The number of lines to draw
                length: 11, // The length of each line
                width: 9, // The line thickness
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
            var target = document.getElementById('spinnerDiv');
            var spinner = new Spinner(opts).spin(target);
            document.getElementById('spinnerDiv').style.display = "block";
            document.getElementById('confirmUploadDiv').style.display = "none";
            document.getElementById('uploadDiv').style.display = "none";
        });
    </script>
</asp:Content>
