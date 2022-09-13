const dayInMsec = 1000 * 60 * 60 * 24;
const hourInMsec = 1000 * 60 * 60;
const minuteInMsec = 1000 * 60;

function calcTimer(millisecondsLeft) {
  const msecLeft = millisecondsLeft < 1000 ? 0 : millisecondsLeft;

  // Time calculations for days, hours, minutes and seconds
  const days = Math.floor(msecLeft / dayInMsec);
  const hours = Math.floor((msecLeft % dayInMsec) / hourInMsec);
  const minutes = Math.floor((msecLeft % hourInMsec) / minuteInMsec);
  const seconds = Math.floor((msecLeft % minuteInMsec) / 1000);

  return days + "d " + hours + "h " + minutes + "m " + seconds + "s";
}

function initializeTimer(id, initialMsecLeft) {
  let msecLeft = initialMsecLeft;
  let timerEl = document.getElementById(id);
  timerEl.innerHTML = calcTimer(msecLeft);

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

    if (msecLeft < 1000) {
      clearInterval(intervalId);
      return;
    }

    timerEl.innerHTML = calcTimer(msecLeft -= 1000);
  }, 1000);

  timerEl.setAttribute('interval-id', intervalId.toString());
}

window.initializeTimer = initializeTimer;
