#include <ApplicationServices/ApplicationServices.h>
#include <CoreFoundation/CoreFoundation.h>

// clang -framework CoreGraphics -framework CoreFoundation sleep-check.c -o sleep-check
// https://gist.github.com/Eun/bc5bfaea5dc06825c551
// CGDisplayIsAsleep(CGMainDisplayID())

int main() {
    if (CGDisplayIsAsleep(CGMainDisplayID())) {
        printf("Asleep");
    } else {
        printf("Awake");
    }
}
