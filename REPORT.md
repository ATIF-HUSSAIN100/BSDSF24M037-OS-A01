# PA-01 Report

## Part 2: Multi-file Project using Make Utility

### Q1: Explain the linking rule in this part's Makefile: $(TARGET): $(OBJECTS). How does it differ from a Makefile rule that links against a library?

The rule $(TARGET): $(OBJECTS) specifies that the target executable (bin/client) depends on all object files (obj/*.o). The command $(CC) $(CFLAGS) -o $@ $^ then links all these object files directly together into one executable. All function code from every .c file gets embedded into the final binary.

In contrast, a Makefile rule that links against a *library* would look like:Here the linker searches for libmyutils.a (static) or libmyutils.so (dynamic) in the specified library directory. The key differences are:

1. *Direct linking* compiles and combines all .c files in one step
2. *Library linking* first builds a .a or .so archive, then links the main program against it
3. Library linking uses -L (path) and -l (library name) flags
4. Library linking enables code reuse — multiple programs can share the same library

### Q2: What is a git tag and why is it useful in a project? What is the difference between a simple tag and an annotated tag?

A *git tag* is a named reference to a specific commit in the repository history. It is useful because:
- It marks important points like releases or stable versions
- Provides a permanent, human-readable label for a specific state of the code
- Makes it easy to checkout, compare, or distribute that exact version later
- Tags don't move like branches — they stay fixed on the commit they were created on

*Simple (lightweight) tag:*
- Just a pointer to a commit
- Created with: git tag v1.0
- Contains no metadata beyond the commit hash

*Annotated tag:*
- A full Git object stored in the database
- Created with: git tag -a v1.0 -m "message"
- Contains the tagger's name, email, date, and a message
- Can be signed with GPG for verification
- Recommended for official releases (which is why we used -a for our assignment)

### Q3: What is the purpose of creating a "Release" on GitHub? What is the significance of attaching binaries (like your client executable) to it?

A *GitHub Release* is a way to package and distribute a specific version of software. It ties together:
- A Git tag
- Release notes/description
- Downloadable assets (binaries, source code, etc.)

*Purpose of a Release:*
- Provides a user-friendly interface for finding and downloading specific versions
- Preserves a snapshot of the project at a specific point
- Communicates to users that this version is stable and ready to use
- Serves as a distribution channel for compiled software

*Significance of attaching binaries:*
- Users may not have the compiler or tools to build from source
- Provides a ready-to-run executable — download and use immediately
- Ensures users get exactly the version you tested and verified
- Essential for distributing software to non-developers
- For our project, bin/client is the actual working program; without it, the release would only contain source code that users would have to compile themselves







---

## Part 3: Static Library

### Q1: Compare the Makefile from Part 2 and Part 3. What are the key differences?

Part 2 Makefile:
- All .c files including main.c compiled and linked together
- Single target: bin/client
- No library involved

Part 3 Makefile:
- New variables: AR, ARFLAGS, LIB, LIB_SRCS, LIB_OBJS
- LIB_SRCS filters out main.c using filter-out so library only contains utility code
- New rule $(LIB): $(LIB_OBJS) uses ar rcs to create lib/libmyutils.a
- Linking uses -L$(LIB_DIR) -lmyutils instead of listing object files
- New target: bin/client_static

Key differences:
1. ar command creates the archive from .o files
2. -L specifies the library search path
3. -lmyutils tells the linker to link against libmyutils.a
4. Library code is separated from the driver (main.c)

### Q2: What is the purpose of the ar command? Why is ranlib often used after it?

ar (archiver) bundles multiple object files into a static library archive (.a file).

Usage: ar rcs libmyutils.a file1.o file2.o
- r = insert or replace files
- c = create archive if it does not exist
- s = write symbol index

ranlib generates the symbol index (symbol table) inside the archive. This lets the linker quickly find which object file defines a symbol.

Historically, ar created the archive and ranlib had to be run separately. Modern ar with the s flag does both automatically, so ranlib is rarely needed now.

### Q3: When you run nm on client_static, are symbols like mystrlen present?

Yes, the symbols are present. Running nm bin/client_static | grep mystrlen shows:

0000000000001268 T mystrlen

The T means the symbol is in the text (code) section and is defined inside the executable.

What this tells us: Static linking copies the actual machine code of library functions into the final executable. The executable is self-contained and does not need libmyutils.a at runtime. This is why static binaries are larger than dynamic ones, and why each program gets its own copy of the code.
















---

## Part 4: Dynamic Library

### Q1: What is Position-Independent Code (-fPIC) and why is it a fundamental requirement for creating shared libraries?

Position-Independent Code (PIC) is machine code that executes correctly regardless of where it is loaded into memory. It uses relative addressing instead of absolute addressing.

Why it's required for shared libraries:
- Shared libraries are loaded at runtime into whatever memory address is available
- The exact load address is not known at compile time
- Without PIC, the library would only work at a specific address
- Multiple programs can share the same library in memory at different virtual addresses
- PIC ensures the code works from any address, enabling memory sharing between processes

### Q2: Explain the difference in file size between your static and dynamic clients. Why does this difference exist?

The static client (client_static) is significantly larger than the dynamic client (client_dynamic).

Why the difference exists:
- Static linking COPIES all library function code directly into the executable
- Dynamic linking only stores REFERENCES (symbol names) to the library functions
- The actual library code remains in the separate .so file
- Multiple programs can share one copy of the dynamic library in memory

### Q3: What is the LD_LIBRARY_PATH environment variable? Why was it necessary to set it for your program to run?

LD_LIBRARY_PATH is an environment variable that specifies additional directories where the dynamic linker should search for shared libraries before searching the standard system directories.

Why it was necessary:
- Our custom library libmyutils.so is in ./lib/, which is not a standard system library path
- The dynamic loader doesn't know where to find custom libraries by default
- Without it, the loader searches only standard paths (/lib, /usr/lib, etc.) and fails with "cannot open shared object file"

What this tells us about the dynamic loader:
- The OS dynamic loader is responsible for finding and loading shared libraries at runtime
- It searches a predefined set of paths plus paths in LD_LIBRARY_PATH
- The loader resolves symbol references by matching them to libraries
- This is why dynamic executables are not self-contained — they depend on the runtime environment
