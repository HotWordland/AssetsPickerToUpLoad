<?php
$targetFolder = 'uploads'; //Path to the Uploads Folder 
/*
ini_set('post_max_size', '20M');
ini_set('upload_max_filesize', '20M');
*/
var_dump($_FILES);
	if (!empty($_FILES)) {
		for($i=0;$i<count($_FILES['upload_file']['name']);$i++){
			$tempFile = $_FILES['upload_file']['tmp_name'][$i];
			$targetFile = rtrim($targetFolder,'/') . '/' . $_FILES['upload_file']['name'][$i];
			$fileTypes = array('jpeg','jpg','png','gif','mov','mp4'); // Allowed File extensions
			$fileParts = pathinfo($_FILES['upload_file']['name'][$i]);
			if(isset($fileParts['extension'])){
				if (in_array($fileParts['extension'],$fileTypes)) {
					move_uploaded_file($tempFile,$targetFile);
					echo '<div class="success">'.$_FILES['upload_file']['name'][$i].' was saved successfully inside '.$targetFolder.' Directory</div>';
				}else{
					echo '<div class="fail">'.$_FILES['upload_file']['name'][$i].' couldn\'t be saved because of invalid file type.</div>' .$fileParts['extension'];
				}
			}else{
				echo '<div class="fail">'.$_FILES['upload_file']['name'][$i].' couldn\'t be saved because of invalid file type.</div>' .$fileParts['extension'] .'没有设置文件类型' .$fileParts['extension'];
				move_uploaded_file($tempFile,$targetFile);
			}
		}
	}

?>
<html>
	<head>
	<script src="//code.jquery.com/jquery-1.10.2.min.js" type="text/javascript"></script>
	<link rel="stylesheet" type="text/css" href="upload.css" media="screen" />
	<script>
        var selDiv = "";
	document.addEventListener("DOMContentLoaded", init, false);

	function init() {
		document.querySelector('#upload_file').addEventListener('change', handleFileSelect, false);
		selDiv = document.querySelector("#selectedFiles");
	}
		
	function handleFileSelect(e) {
		if(!e.target.files) return;
		var files = e.target.files;
		for(var i=0; i<files.length; i++) {
			var f = files[i];
			selDiv.innerHTML += "<div class='file_list'>"+f.name + "</div>";
		}
                $('#uploadimages').show();
	}
	
	$(document).ready(function(){
	    $("#uploadTrigger").click(function(){
		$("#upload_file").click();
            });	
	});

	</script>

	</head>
	<body>
	
		<div id="upload_pages">
		    
		   <form action="upload.php" enctype="multipart/form-data" method="POST">
		
			<input type="hidden" name="AddFiles" id="AddFiles" value="1">
		
			<input type="file" name="upload_file[]" class="hidden" id="upload_file" multiple />
		
			<hr>
			<strong id="form-text">Upload Images </strong>
			<div class="button" id="uploadTrigger">Select Images</div>
			<hr>
			
			<div id="selectedFiles"></div>    
			<input type="submit" value="Upload" id="uploadimages" />
		   </form>
		</div>

	</body>
</html>
