$(document).ready(function () {
  // Initialize EmailJS (only if you're using EmailJS)
  emailjs.init("hEubSTaTwdmPBBdTW"); // e.g. "hEubSTaTwdmPBBdTW"

  $("#contactForm").on("submit", function (event) {
    event.preventDefault();

    // Basic front-end form gathering
    const name = $("#name").val().trim();
    const email = $("#email").val().trim();
    const phone = $("#phone").val().trim();
    const contactMethod = $("#contactMethod").val();
    const message = $("#message").val().trim();

    if (!name || !email || !message) {
      alert("Please fill in required fields: Name, Email, and Message.");
      return;
    }

    // If using EmailJS, prepare the data to match your EmailJS template
    const templateParams = {
      from_name: name,
      from_email: email,
      phone: phone,
      contact_method: contactMethod,
      message: message,
    };

    // Send via EmailJS (replace with your actual IDs)
    emailjs
      .send("service_1ihscpf", "template_vcw721k", templateParams)
      .then(
        function (response) {
          console.log("SUCCESS!", response.status, response.text);
          alert("Your message has been sent!");
          $("#contactForm")[0].reset();
        },
        function (error) {
          console.log("FAILED...", error);
          alert("Oops! Something went wrong. Please try again later.");
        }
      );
  });
});
