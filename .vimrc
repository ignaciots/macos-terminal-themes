syntax on
set background=dark   " or light, depending on your Terminal theme
set t_Co=256
set number
" Compile current C++ file with C++17 and run it.
function! CompileAndRun()
  " 1. Save the file
  write

  " 2. Clear old quickfix list and errors
  cclose
  silent! lclose

  " 3. Build the compile command
  let fname   = expand('%:t')   " e.g. test.cpp
  let target  = expand('%:r')   " e.g. main
  let compile = 'clang++ -std=c++17 "' . fname . '" -o "' . target . '" 2>&1'

  " 4. Run the compiler, capture all output
  let output  = system(compile)

  " 5. If compilation failed, show errors in the quickfix list
  if v:shell_error
        " load compiler output directly into quickfix
        cexpr split(output, "\n")
        copen
        echohl ErrorMsg | echom "Build failed" | echohl None
  else
        " 6. Compilation succeeded – run the program
        if has('terminal')
              " Use a terminal split if your Vim supports it
              belowright split | resize 12 | execute 'terminal ./'.target
        else
              " Fallback: capture program output into a scratch buffer
              botright new
              setlocal buftype=nofile bufhidden=wipe nobuflisted
              call setline(1, 'Running ./' .target.' …')
              execute 'read !./'.target
              normal! gg
        endif
  endif
endfunction

" Normal‑mode Ctrl‑B runs the function
nnoremap <C-b> :call CompileAndRun()<CR>


