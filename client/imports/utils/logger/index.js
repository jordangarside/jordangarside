let logger;
let debug;

if (process.env.NODE_ENV === "development") {
  debug = true;
} else {
  debug = false;
}

if (debug) {
  logger = console;
} else {
  logger = {
    info: () => {},
    debug: () => {},
    warn: () => {},
    log: () => {}
  };
}

export { logger };
export default logger;
