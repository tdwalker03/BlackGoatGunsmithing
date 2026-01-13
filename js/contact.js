$(document).ready(function () {
  // Initialize EmailJS
  emailjs.init("hEubSTaTwdmPBBdTW");

  $("#contactForm").on("submit", function (event) {
    event.preventDefault();

    // Basic front-end form gathering
    const name = $("#name").val().trim();
    const email = $("#email").val().trim();
    const phone = $("#phone").val().trim();
    const contactMethod = $("#contactMethod").val();
    const message = $("#message").val().trim();
    const submitBtn = $("#submit-btn");
    const successDiv = $("#success");

    // Clear previous messages
    successDiv.html("");

    // Validation
    if (!name || !email || !message) {
      successDiv.html(
        '<div class="alert alert-danger mt-3">Please fill in required fields: Name, Email, and Message.</div>'
      );
      return;
    }

    // Email validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      successDiv.html(
        '<div class="alert alert-danger mt-3">Please enter a valid email address.</div>'
      );
      return;
    }

    // Show loading state
    submitBtn.prop("disabled", true);
    submitBtn.html('<i class="fas fa-spinner fa-spin"></i> Sending...');

    // Prepare EmailJS template parameters
    const templateParams = {
      from_name: name,
      from_email: email,
      phone: phone,
      contact_method: contactMethod,
      message: message,
    };

    // Send via EmailJS
    emailjs
      .send("service_1ihscpf", "template_vcw721k", templateParams)
      .then(
        function (response) {
          console.log("SUCCESS!", response.status, response.text);
          successDiv.html(
            '<div class="alert alert-success mt-3"><strong>Success!</strong> Your message has been sent. We\'ll get back to you soon!</div>'
          );
          $("#contactForm")[0].reset();

          // Reset button after 2 seconds
          setTimeout(function() {
            submitBtn.prop("disabled", false);
            submitBtn.html("Send Message");
            successDiv.html("");
          }, 5000);
        },
        function (error) {
          console.log("FAILED...", error);
          successDiv.html(
            '<div class="alert alert-danger mt-3"><strong>Error!</strong> Something went wrong. Please try again or call us directly.</div>'
          );

          // Reset button
          submitBtn.prop("disabled", false);
          submitBtn.html("Send Message");
        }
      );
  });
});
