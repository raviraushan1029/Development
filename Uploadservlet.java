import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;

@MultipartConfig(location="/tmp", maxFileSize=5242880) // 5MB max
public class UploadServlet extends HttpServlet {
    private static final String UPLOAD_DIR = "uploads";
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Get the upload directory path
        String applicationPath = request.getServletContext().getRealPath("");
        String uploadPath = applicationPath + File.separator + UPLOAD_DIR;
        
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        try {
            Part filePart = request.getPart("file");
            String fileName = filePart.getSubmittedFileName();
            
            // Save the file
            filePart.write(uploadPath + File.separator + fileName);
            
            // Store filename in session
            HttpSession session = request.getSession();
            session.setAttribute("uploadedFile", fileName);
            
            response.sendRedirect("uploadFile.jsp");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "File upload failed");
        }
    }
}
