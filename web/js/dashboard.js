/* ===== TRACKSAFE DASHBOARD JS ===== */

function initSidebar() {
  var body = document.body;
  var stored = localStorage.getItem('sidebarCollapsed');
  if (stored === 'true') body.classList.add('sidebar-collapsed');

  document.querySelectorAll('.sidebar-toggle-btn, .topbar-toggle').forEach(function(btn) {
    btn.addEventListener('click', function() {
      if (window.innerWidth <= 900) {
        var sidebar = document.querySelector('.sidebar');
        if (sidebar) sidebar.classList.toggle('mobile-open');
      } else {
        body.classList.toggle('sidebar-collapsed');
        localStorage.setItem('sidebarCollapsed', body.classList.contains('sidebar-collapsed'));
      }
    });
  });

  document.addEventListener('click', function(e) {
    if (window.innerWidth <= 900) {
      var sidebar = document.querySelector('.sidebar');
      if (sidebar && sidebar.classList.contains('mobile-open') &&
          !sidebar.contains(e.target) && !e.target.closest('.topbar-toggle')) {
        sidebar.classList.remove('mobile-open');
      }
    }
  });
}

function setActiveNav() {
  var page = window.location.pathname.split('/').pop();
  document.querySelectorAll('.nav-item').forEach(function(item) {
    var href = (item.getAttribute('href') || '').split('/').pop();
    if (href && href !== '#' && href.toLowerCase() === page.toLowerCase()) {
      item.classList.add('active');
    }
  });
}

function showToast(message, type) {
  var old = document.querySelector('.ts-toast');
  if (old) old.remove();
  var t = document.createElement('div');
  t.className = 'ts-toast ' + (type || 'success');
  t.innerHTML = '<span>' + (type==='error'?'✕':'✓') + '</span> ' + message;
  document.body.appendChild(t);
  setTimeout(function() {
    t.style.cssText += 'opacity:0;transition:opacity 0.4s;';
    setTimeout(function() { t.remove(); }, 400);
  }, 3500);
}

function initSlideshow() {
  var slides = document.querySelectorAll('.slides');
  var dots   = document.querySelectorAll('.dot');
  var idx = 0, timer;
  if (!slides.length) return;

  function show(n) {
    slides.forEach(function(s) { s.classList.remove('active'); });
    dots.forEach(function(d)   { d.classList.remove('active'); });
    idx = (n + slides.length) % slides.length;
    slides[idx].classList.add('active');
    if (dots[idx]) dots[idx].classList.add('active');
  }

  window.currentSlide = function(n) {
    clearInterval(timer);
    show(n - 1);
    timer = setInterval(function() { show(idx + 1); }, 4500);
  };

  show(0);
  timer = setInterval(function() { show(idx + 1); }, 4500);
}

function initReveal() {
  if (!window.IntersectionObserver) return;
  var obs = new IntersectionObserver(function(entries) {
    entries.forEach(function(e) {
      if (e.isIntersecting) {
        e.target.style.opacity = '1';
        e.target.style.transform = 'translateY(0)';
      }
    });
  }, { threshold: 0.08 });
  document.querySelectorAll('.stat-card, .result-item, .group-card').forEach(function(el) {
    el.style.opacity = '0';
    el.style.transform = 'translateY(16px)';
    el.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
    obs.observe(el);
  });
}

document.addEventListener('DOMContentLoaded', function() {
  initSidebar();
  setActiveNav();
  initSlideshow();
  setTimeout(initReveal, 80);
  document.querySelectorAll('[id^="chatArea-"]').forEach(function(el) {
    el.scrollTop = el.scrollHeight;
  });
});