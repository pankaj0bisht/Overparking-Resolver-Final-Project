OVERPARKING RESOLVER - PHASE 3
Smart Campus Parking Reservation, Redirection and Priority Waitlist System

============================================================
1. SIMPLE PROJECT FOLDER
============================================================

Overparking_Resolver_Phase3/
    HTML/
        index.html       (HTML + CSS + JavaScript in ONE file)
    CPP/
        backend.cpp      (C++ OOP + DSA + local HTTP server)
    build_windows.bat
    run_windows.bat
    README.txt

You do not need separate style.css or app.js files. The browser loads
one frontend page: HTML/index.html. Its CSS is inside a <style> section
and its JavaScript is inside a <script> section.

============================================================
2. HOW THE FRONTEND AND BACKEND WORK TOGETHER
============================================================

1. Start the C++ program. It runs a local web server.
2. Open http://127.0.0.1:8765 in Chrome or Edge.
3. The C++ server sends HTML/index.html to the browser.
4. The JavaScript inside index.html sends form data to /api/... routes.
5. C++ receives the request, runs the parking rules and DSA algorithms,
   and sends JSON back.
6. JavaScript updates the dashboard and tables using that response.

JavaScript only connects the interface to C++ and displays responses.
The parking decisions, reservation logic, graph traversal and emergency
allocation are performed by C++.

============================================================
3. PROJECT FEATURES
============================================================

- Dashboard with parking capacity and block occupancy.
- Vehicle registration for two-wheelers, four-wheelers and emergency
  vehicles, with Student, Faculty and Emergency priority categories.
- Standard reservation, automatic redirection, cancellation, check-in
  and undo.
- Priority waitlist: Emergency, then Faculty, then Student; FIFO within
  each priority.
- Emergency allocation using an adjacency matrix and BFS. C++ chooses
  the nearest reachable block with free space and returns the route.
- Graph page showing adjacency matrix and BFS/DFS traversal calculated
  in C++.
- No-show register using a Binary Search Tree.
- Fines, 80% capacity alerts, occupancy report and activity log.
- Activity log can be saved to a text file.

The emergency AI is an explainable, rule-based allocator. It is not a
trained machine-learning model.

============================================================
4. OOP AND DSA USED
============================================================

OOP: classes and objects, encapsulation, abstraction, inheritance,
runtime polymorphism, virtual functions, constructors, copy constructor,
destructors, operator overloading, function template and exception
handling.

Custom DSA without STL containers: arrays, pointers, dynamic arrays,
stack, linked lists, doubly linked list, linked priority queues, binary
search tree, hash table with chaining, adjacency matrix, BFS, DFS,
insertion sort, quick sort and binary search.

The project demonstrates selected topics from the semester syllabus;
it does not claim to implement every topic in the complete syllabus.

============================================================
5. RUN IN VS CODE ON WINDOWS
============================================================

STEP 1 - Install the compiler once
- Install MSYS2 from https://www.msys2.org/ if it is not already set up.
- Open MSYS2 UCRT64.
- Run:
    pacman -S --needed mingw-w64-ucrt-x86_64-gcc
- Add C:\msys64\ucrt64\bin to Windows PATH.
- Reopen VS Code and check in its terminal:
    g++ --version

STEP 2 - Open the project
- Extract the ZIP.
- Open VS Code -> File -> Open Folder.
- Select the Overparking_Resolver_Phase3 folder.

STEP 3 - Build the C++ backend
- In the VS Code terminal, run:
    .\build_windows.bat
  Or compile directly:
    g++ -std=c++11 -Wall -Wextra -pedantic CPP\backend.cpp -o parking_server.exe -lws2_32

STEP 4 - Start the server
- Run:
    .\run_windows.bat
  Keep this terminal open while using the website.

STEP 5 - Open the website
- Open this address in your browser:
    http://127.0.0.1:8765
- Do not double-click index.html and do not use Live Server. The page
  must be served by the C++ backend so its /api routes work.
- Stop the server with Ctrl+C.

============================================================
6. PHASE 2 MODULE CONTINUITY
============================================================

The combined backend retains the four Phase 2 modules:
1. Vehicle & Priority.
2. Parking Slot & Block.
3. Fine, Alert & Report.
4. Reservation & Resolver.

The Phase 2 proposal listed BFS/DFS graph search, a hash table and file
handling as planned improvements. These have been incorporated into the
Phase 3 code. The C++ file remains integrated as one backend source file
so the team can build and run the project without linking several
separate member source files.

============================================================
7. IMPORTANT TESTING NOTE
============================================================

The C++ backend must be compiled and run on the target Windows computer
to confirm the local MSYS2 setup. If the build fails, copy the complete
error from the VS Code terminal so the exact issue can be fixed.

============================================================
8. HOW HTML CONNECTS TO C++ (CONNECTION MAP)
============================================================

The connection is already built in, and it was verified end-to-end on
16 Nov 2026 (compiled clean with -Wall -Wextra -pedantic, and every
route below was tested live against the running server):

  Browser (HTML/index.html, one file: HTML + CSS + JavaScript)
      |  GET  /              -> C++ serveStaticFile() sends HTML/index.html
      |  GET  /api/state     -> buildStateJson(): summary, blocks, vehicles,
      |                         reservations, waitlist, no-shows, logs,
      |                         adjacency matrix, last AI decision
      |  GET  /api/graph?start=A -> buildGraphJson(): BFS + DFS from C++
      |  POST /api/register-vehicle   (vehicleNumber, owner, type, category)
      |  POST /api/make-reservation   (vehicleNumber, blockId)
      |  POST /api/emergency-allocate (vehicleNumber, owner, entryBlock)
      |  POST /api/reservation-action (action=checkin/cancel/noshow/undo,
      |                               reservationId, minutesLate)
      |  POST /api/save-log
      v
  C++ (CPP/backend.cpp, port 8765, http://127.0.0.1:8765)
  handleConnection() routes each request, processHtmlPost() runs the
  same ReservationManager / BlockMap / PriorityWaitlist / NoShowTree /
  FineManager classes as the console demo, and replies with JSON
  {"message": "..."}. JavaScript only displays the reply; all parking
  decisions are made in C++.

  Verified live on 16 Nov 2026:
  - GET / returns the full page (200, 44,822 bytes); /api/state returns
    total 5 slots (A=2, B=2, C=1), matrix [[0,1,0],[1,0,1],[0,1,0]],
    BFS/DFS from A = A -> B -> C.
  - Register, duplicate-vehicle guard, double-booking guard and
    unregistered-vehicle guard all return the correct message.
  - Reservation, emergency BFS allocation, check-in, no-show fine
    (40 min late = Rs 60), full-campus waitlist, promotion from the
    waitlist on cancel, undo, and save-log all work.
  - Built-in self-test: g++ -DPARKING_SELF_TEST => 16 passed, 0 failed.

  Two small fixes made while connecting (16 Nov 2026):
  1. A failed reservation used to write a confusing extra line
     ("Reservation exception rethrown...") into the activity log.
     The real error message is now passed through untouched.
  2. Unknown /api/... routes used to return an HTML 404 page, which
     would break fetch().response.json(). They now return JSON 404.

  Two more fixes made after a real browser test (16 Nov 2026):
  3. Chrome/Edge open extra idle connections when loading a page.
     The server used to wait forever on a silent connection, so the
     real page request never got answered and the browser showed an
     error. Each connection now has a 5-second timeout, and a
     connection that sends nothing is closed silently.
  4. If a browser closed a connection while the server was replying,
     the server used to crash (SIGPIPE). The server now ignores that
     signal and carries on serving the next request.

============================================================
9. TROUBLESHOOTING
============================================================

"Could not load data from the C++ backend."
  -> You opened HTML/index.html by double-clicking it (the address
     bar shows .../HTML/index.html). That loads the page as a file,
     and a file cannot reach the C++ server. Close that tab, start
     the server with run_windows.bat, and open this address instead:
         http://127.0.0.1:8765
     Keep the server terminal open while you use the site. If the
     address bar does not start with http://127.0.0.1:8765, the
     buttons cannot work, no matter what you type in the forms.

"Reservation failed / Register this vehicle first"
  -> Register the vehicle on the Vehicles page first, then make the
     reservation with the same vehicle number.

The page loads but a reservation does nothing
  -> Check the server terminal: it must still be running and must
     show "Campus Parking backend is running." If it closed, run
     run_windows.bat again. Then refresh the page.

  Linux / macOS users can build and run with the included scripts:
      ./build_linux.sh
      ./run_linux.sh
  then open http://127.0.0.1:8765 (same address as on Windows).
