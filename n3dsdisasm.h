#include <stdbool.h>
#include <stdint.h>
#include <stddef.h>

enum BranchType
{
    BRANCH_TYPE_UNKNOWN,
    BRANCH_TYPE_PROBABLY_BL,
    BRANCH_TYPE_B,
    BRANCH_TYPE_BL,
};

enum LabelType
{
    LABEL_ARM_CODE,
    LABEL_THUMB_CODE,
    LABEL_DATA,
    LABEL_POOL,
    LABEL_JUMP_TABLE,
};

enum LabelOriginType
{
    LABEL_ORIGIN_ENTRY,
    LABEL_ORIGIN_BRANCH,
    LABEL_ORIGIN_FUNC_CALL,
    LABEL_ORIGIN_TAIL_CALL,
    LABEL_ORIGIN_FUNC_RETURN,
    LABEL_ORIGIN_POOL_LOAD,
    LABEL_ORIGIN_JUMP_TABLE,
};

struct LabelOrigin
{
    enum LabelOriginType type;
    int callerLabel;
    uint32_t callerAddr;
    char callerInstruction[64];
};

extern uint8_t *gInputFileBuffer;
extern size_t gInputFileBufferSize;
extern uint32_t ROM_LOAD_ADDR;
extern bool gStandaloneFlag;

// disasm.c
int disasm_add_label(uint32_t addr, uint8_t type, char *name, struct LabelOrigin* origin);
int disasm_set_branch_type(uint32_t addr, uint32_t type, bool farJump);
void disasm_force_func(int idx);
void disasm_force_data(int idx);
void disasm_disassemble(void);
int jump_table_create_labels(uint32_t start, int count);
