<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="CopyCat._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <!------------------------- Initial Form ------->
    <div id="dbFormArea" runat="server">
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

</asp:Content>
