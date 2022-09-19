const dayInMsec = 1000 * 60 * 60 * 24;
const hourInMsec = 1000 * 60 * 60;
const minuteInMsec = 1000 * 60;

function calcTimer(distance) {
  // Time calculations for days, hours, minutes and seconds
  const days = Math.floor(distance / dayInMsec);
  const hours = Math.floor((distance % dayInMsec) / hourInMsec);
  const minutes = Math.floor((distance % hourInMsec) / minuteInMsec);
  const seconds = Math.floor((distance % minuteInMsec) / 1000);

  let value = '';
  if (days > 0) value += days + "d ";
  if (hours > 0) value += hours + "h ";
  if (minutes > 0) value += minutes + "m ";
  value += seconds + "s";
  return value;
}

function calcDistance(countdownMs) {
  const now = new Date().getTime();
  const distance = countdownMs - now;
  return distance < 0 ? 0 : distance;
}

function initializeTimer(id, countdownMs) {
  let timerEl = document.getElementById(id);
  let distance = calcDistance(countdownMs);
  timerEl.innerHTML = calcTimer(distance);

  const intervalId = setInterval(() => {
    timerEl = document.getElementById(id);
    if (!timerEl) {
      clearInterval(intervalId);
      return;
    }

    const currIntervalId = parseInt(timerEl.getAttribute('interval-id'));
    if (currIntervalId && currIntervalId !== intervalId) {
      clearInterval(intervalId);
      return;
    }

    distance = calcDistance(countdownMs);
    if (distance < 0) {
      clearInterval(intervalId);
      return;
    }

    timerEl.innerHTML = calcTimer(distance);
  }, 1000);

  timerEl.setAttribute('interval-id', intervalId.toString());
}

window.initializeTimer = initializeTimer;
