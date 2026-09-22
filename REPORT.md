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
