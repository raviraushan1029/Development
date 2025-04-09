<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>File Upload</title>
    <style>
        .uploaded-file {
            margin: 10px 0;
            padding: 5px;
            border: 1px solid #ccc;
            display: inline-flex;
            align-items: center;
        }
        .delete-btn {
            margin-left: 10px;
            color: red;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <h2>Upload CSV File</h2>
    <form id="uploadForm" enctype="multipart/form-data" method="post" action="UploadServlet">
        <input type="file" id="fileInput" name="file" accept=".csv"><br><br>
        <input type="button" value="Upload" onclick="validateAndSubmit()">
    </form>

    <div id="uploadedFiles">
        <% 
            String uploadedFile = (String) session.getAttribute("uploadedFile");
            if (uploadedFile != null) {
        %>
            <div class="uploaded-file">
                <a href="ViewServlet?filename=<%=uploadedFile%>" target="_blank"><%=uploadedFile%></a>
                <span class="delete-btn" onclick="deleteFile('<%=uploadedFile%>')">❌</span>
            </div>
        <% 
            }
        %>
    </div>

    <script>
        function validateAndSubmit() {
            const fileInput = document.getElementById('fileInput');
            const file = fileInput.files[0];
            
            if (!file) {
                alert('Please select a file');
                return;
            }

            // Check file extension
            if (!file.name.endsWith('.csv')) {
                alert('Please select a CSV file only');
                return;
            }

            // Check file size (5MB = 5 * 1024 * 1024 bytes)
            if (file.size > 5 * 1024 * 1024) {
                alert('File size should not exceed 5MB');
                return;
            }

            // If validation passes, submit the form
            document.getElementById('uploadForm').submit();
        }

        function deleteFile(filename) {
            if (confirm('Are you sure you want to delete ' + filename + '?')) {
                fetch('DeleteServlet?filename=' + encodeURIComponent(filename), {
                    method: 'POST'
                })
                .then(response => {
                    if (response.ok) {
                        location.reload();
                    } else {
                        alert('Error deleting file');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error deleting file');
                });
            }
        }
    </script>
</body>
</html>
