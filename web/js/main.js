/* ===== TRACKING SYSTEM - MAIN JS ===== */

// ===== SLIDESHOW =====
(function () {
  var slides = document.querySelectorAll('.slides');
  var dots   = document.querySelectorAll('.dot');
  var idx = 0;
  var timer;

  function showSlide(n) {
    slides.forEach(function(s){ s.classList.remove('active'); });
    dots.forEach(function(d){ d.classList.remove('active'); });
    idx = (n + slides.length) % slides.length;
    slides[idx].classList.add('active');
    if (dots[idx]) dots[idx].classList.add('active');
  }

  function nextSlide() {
    showSlide(idx + 1);
  }

  window.currentSlide = function(n) {
    clearInterval(timer);
    showSlide(n - 1);
    timer = setInterval(nextSlide, 4500);
  };

  if (slides.length > 0) {
    showSlide(0);
    timer = setInterval(nextSlide, 4500);
  }
})();

// ===== FORM VALIDATION =====
function Validate_Data(flag) {
  var pass = document.querySelector('[name="password"]');
  var cpass = document.querySelector('[name="confirm_password"]');
  var mobile = document.querySelector('[name="mobile"]');
  var aadhar = document.querySelector('[name="aadhar_no"]');

  if (pass && cpass && pass.value !== cpass.value) {
    showToast('Passwords do not match!', 'error');
    return false;
  }

  if (mobile && (mobile.value.length < 10 || mobile.value.length > 10)) {
    showToast('Mobile number must be exactly 10 digits.', 'error');
    return false;
  }

  if (aadhar && aadhar.value.toString().length !== 12) {
    showToast('Aadhaar number must be 12 digits.', 'error');
    return false;
  }

  return true;
}

function validateAll(flag) {
  return true;
}

// ===== TOAST NOTIFICATION =====
function showToast(message, type) {
  var existing = document.querySelector('.ts-toast');
  if (existing) existing.remove();

  var toast = document.createElement('div');
  toast.className = 'ts-toast';
  toast.textContent = message;
  toast.style.cssText = [
    'position:fixed', 'top:90px', 'right:24px', 'z-index:9999',
    'padding:14px 24px', 'border-radius:12px',
    'font-family:Outfit,sans-serif', 'font-size:0.92rem', 'font-weight:600',
    'box-shadow:0 8px 28px rgba(0,0,0,0.18)',
    'animation:toastIn 0.35s cubic-bezier(.34,1.56,.64,1) forwards',
    type === 'error'
      ? 'background:linear-gradient(135deg,#ff4d4f,#d32f2f);color:#fff;'
      : 'background:linear-gradient(135deg,#00c9a7,#00897b);color:#fff;'
  ].join(';');

  var style = document.createElement('style');
  style.textContent = '@keyframes toastIn{from{opacity:0;transform:translateX(40px)}to{opacity:1;transform:translateX(0)}}';
  document.head.appendChild(style);

  document.body.appendChild(toast);
  setTimeout(function(){ toast.style.opacity='0'; toast.style.transition='opacity 0.4s'; setTimeout(function(){ toast.remove(); }, 400); }, 3500);
}

// ===== SCROLL ANIMATIONS =====
function initScrollAnimations() {
  var observer = new IntersectionObserver(function(entries){
    entries.forEach(function(entry){
      if (entry.isIntersecting) {
        entry.target.style.opacity = '1';
        entry.target.style.transform = 'translateY(0)';
      }
    });
  }, { threshold: 0.12 });

  document.querySelectorAll('.feature-box, .col-lg-6, .content').forEach(function(el){
    el.style.opacity = '0';
    el.style.transform = 'translateY(28px)';
    el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
    observer.observe(el);
  });
}

document.addEventListener('DOMContentLoaded', function() {
  initScrollAnimations();

  // Active nav link
  var currentPath = window.location.pathname.split('/').pop();
  document.querySelectorAll('nav ul li a').forEach(function(link){
    if (link.getAttribute('href') === currentPath) {
      link.style.background = 'rgba(255,255,255,0.22)';
      link.style.color = '#fff';
    }
  });
});
