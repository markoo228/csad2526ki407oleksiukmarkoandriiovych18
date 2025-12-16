@echo off
REM Robust CI batch script for Windows (cmd.exe)
REM - creates build directory if missing
REM - configures with cmake
REM - builds unit_tests and attempts run_tests; otherwise runs ctest directly

SETLOCAL ENABLEDELAYEDEXPANSION
SET CONFIG=Release

REM find cmake (use PATH or common install locations)
where cmake >nul 2>nul || (
  if exist "%ProgramFiles%\CMake\bin\cmake.exe" (
    set "CMAKE_CMD=%ProgramFiles%\CMake\bin\cmake.exe"
  ) else if exist "%ProgramFiles(x86)%\CMake\bin\cmake.exe" (
    set "CMAKE_CMD=%ProgramFiles(x86)%\CMake\bin\cmake.exe"
  ) else (
    echo FAILED: cmake not found in PATH and common locations
    exit /b 2
  )
)
if not defined CMAKE_CMD set "CMAKE_CMD=cmake"
echo Using %CMAKE_CMD%

REM create build dir if not exists
if not exist "build" (
  mkdir "build"
)

REM configure
echo === Configuring ===
"%CMAKE_CMD%" -S . -B build -DCMAKE_BUILD_TYPE=%CONFIG%
if ERRORLEVEL 1 (
  echo FAILED: cmake configuration failed
  exit /b 1
)

REM build unit_tests
echo === Building unit_tests ===
"%CMAKE_CMD%" --build build --config %CONFIG% --target unit_tests
if ERRORLEVEL 1 (
  echo FAILED: build unit_tests failed
  exit /b 1
)

REM try run_tests target first
echo === Attempting run_tests target ===
"%CMAKE_CMD%" --build build --config %CONFIG% --target run_tests >nul 2>&1
if %ERRORLEVEL% EQU 0 (
  echo run_tests target executed
  echo SUCCESS: tests executed via run_tests
  exit /b 0
)

REM fallback to ctest
echo === Falling back to ctest ===
where ctest >nul 2>nul || (
  if exist "%ProgramFiles%\CMake\bin\ctest.exe" (
    set "CTEST_CMD=%ProgramFiles%\CMake\bin\ctest.exe"
  ) else if exist "%ProgramFiles(x86)%\CMake\bin\ctest.exe" (
    set "CTEST_CMD=%ProgramFiles(x86)%\CMake\bin\ctest.exe"
  ) else (
    echo FAILED: ctest not found in PATH and common locations
    exit /b 2
  )
)
if not defined CTEST_CMD set "CTEST_CMD=ctest"

"%CTEST_CMD%" --test-dir build -C %CONFIG% --output-on-failure
if ERRORLEVEL 1 (
  echo FAILED: tests failed
  exit /b 1
)

echo SUCCESS: configuration, build and tests passed
exit /b 0

@echo off
REM Robust CI batch script for Windows (cmd.exe)
REM - creates build directory if missing
REM - configures with cmake
REM - builds unit_tests and attempts run_tests; otherwise runs ctest directly

SETLOCAL ENABLEDELAYEDEXPANSION
SET CONFIG=Release

REM find cmake (use PATH or common install locations)
where cmake >nul 2>nul || (
	if exist "%ProgramFiles%\CMake\bin\cmake.exe" (
		set "CMAKE_CMD=%ProgramFiles%\CMake\bin\cmake.exe"
	) else if exist "%ProgramFiles(x86)%\CMake\bin\cmake.exe" (
		set "CMAKE_CMD=%ProgramFiles(x86)%\CMake\bin\cmake.exe"
	) else (
		echo FAILED: cmake not found in PATH and common locations
		exit /b 2
	)
)
if not defined CMAKE_CMD set "CMAKE_CMD=cmake"
echo Using %CMAKE_CMD%

REM create build dir if not exists
if not exist "build" (
	mkdir "build"
)

REM configure
echo === Configuring ===
%CMAKE_CMD% -S .. -B build -DCMAKE_BUILD_TYPE=%CONFIG%
if ERRORLEVEL 1 (
	echo FAILED: cmake configuration failed
	exit /b 1
)

REM build unit_tests
echo === Building unit_tests ===
%CMAKE_CMD% --build build --config %CONFIG% --target unit_tests
if ERRORLEVEL 1 (
	echo FAILED: build unit_tests failed
	exit /b 1
)

REM try run_tests target first
echo === Attempting run_tests target ===
%CMAKE_CMD% --build build --config %CONFIG% --target run_tests >nul 2>&1
if ERRORLEVEL 0 (
	echo run_tests target executed
	echo SUCCESS: tests executed via run_tests
	exit /b 0
)

REM fallback to ctest
echo === Falling back to ctest ===
where ctest >nul 2>nul || (
	if exist "%ProgramFiles%\CMake\bin\ctest.exe" (
		set "CTEST_CMD=%ProgramFiles%\CMake\bin\ctest.exe"
	) else if exist "%ProgramFiles(x86)%\CMake\bin\ctest.exe" (
		set "CTEST_CMD=%ProgramFiles(x86)%\CMake\bin\ctest.exe"
	) else (
		echo FAILED: ctest not found in PATH and common locations
		exit /b 2
	)
)
if not defined CTEST_CMD set "CTEST_CMD=ctest"

%CTEST_CMD% --test-dir build -C %CONFIG% --output-on-failure
if ERRORLEVEL 1 (
	echo FAILED: tests failed
	exit /b 1
)

echo SUCCESS: configuration, build and tests passed
exit /b 0
@echo off
REM Простий CI-скрипт для Windows: конфігурація, збірка та запуск тестів через CMake

SETLOCAL ENABLEDELAYEDEXPANSION























exit /b 1popd 2>nulecho FAILED: сталася помилка під час конфігурації/зборки/тестів
n:failedexit /b 0popd
necho SUCCESS: конфігурація, збірка та тести пройшли успішноctest -C Release --output-on-failure
if ERRORLEVEL 1 goto failed
necho === Запуск тестів (ctest) ===cmake --build .
if ERRORLEVEL 1 goto failed
necho === Збірка (cmake --build .) ===cmake ..
if ERRORLEVEL 1 goto failed
necho === Конфігурація (cmake ..) ===)  exit /b 1  echo FAILED: не вдалось перейти в каталог buildpushd build || (
nREM перейти в каталог build)  mkdir "build"if not exist "build" (nREM створити каталог build, якщо не існує