/**
*   @file    Crypto_CseTypes.h
*
*   @version 1.0.2
*
*   @brief   AUTOSAR Crypto - Crypto CSE Types.
*   @details Contains the Crypto CSE Types that are exported
*
*   @addtogroup Crypto
*   @{
*/
/*==================================================================================================
*   Project              : AUTOSAR 4.3 MCAL
*   Platform             : ARM
*   Peripheral           : Crypto
*   Dependencies         : none
*
*   Autosar Version      : 4.3.1
*   Autosar Revision     : ASR_REL_4_3_REV_0001
*   Autosar Conf.Variant :
*   SW Version           : 1.0.2
*   Build Version        : S32K1XX_MCAL_1_0_2_RTM_ASR_REL_4_3_REV_0001_23-Apr-21
*
*   (c) Copyright 2006-2016 Freescale Semiconductor, Inc. 
*       Copyright 2017-2021 NXP
*   All Rights Reserved.
==================================================================================================*/
/*==================================================================================================
==================================================================================================*/

#ifndef CRYPTO_CSETYPES_H
#define CRYPTO_CSETYPES_H

#ifdef __cplusplus
extern "C"{
#endif

/**
* @page misra_violations MISRA-C:2004 violations
*
* @section [global]
*          Violates MISRA 2004 Required Rule 5.1, Identifiers (internal and external) shall not rely 
*          on the significance of more than 31 characters. The used compilers use more than 31 chars 
*          for identifiers.
*/

/*==================================================================================================
*                                        INCLUDE FILES
* 1) system and project includes
* 2) needed interfaces from external units
* 3) internal and external interfaces from this unit
==================================================================================================*/

#include "Std_Types.h"
#include "Crypto_Cfg.h"
#include "Crypto_Types.h"

/*==================================================================================================
*                              SOURCE FILE VERSION INFORMATION
==================================================================================================*/
/**
* @file           Crypto_CseTypes.h
*/
#define CRYPTO_CSETYPES_H_VENDOR_ID                    43
#define CRYPTO_CSETYPES_H_AR_RELEASE_MAJOR_VERSION     4
#define CRYPTO_CSETYPES_H_AR_RELEASE_MINOR_VERSION     3
#define CRYPTO_CSETYPES_H_AR_RELEASE_REVISION_VERSION  1
#define CRYPTO_CSETYPES_H_SW_MAJOR_VERSION             1
#define CRYPTO_CSETYPES_H_SW_MINOR_VERSION             0
#define CRYPTO_CSETYPES_H_SW_PATCH_VERSION             2

/*==================================================================================================
*                                     FILE VERSION CHECKS
==================================================================================================*/
/* Check if current file and Std_Types header file are of the same Autosar version */
#ifndef DISABLE_MCAL_INTERMODULE_ASR_CHECK
    #if ((CRYPTO_CSETYPES_H_AR_RELEASE_MAJOR_VERSION != STD_AR_RELEASE_MAJOR_VERSION) || \
         (CRYPTO_CSETYPES_H_AR_RELEASE_MINOR_VERSION != STD_AR_RELEASE_MINOR_VERSION))
        #error "AutoSar Version Numbers of Crypto_CseTypes.h and Std_Types.h are different"
    #endif
#endif

/*==================================================================================================
*                                          CONSTANTS
==================================================================================================*/


/*==================================================================================================
*                                      DEFINES AND MACROS
==================================================================================================*/

#define CRYPTO_CSE_KE_SHE_M1_OFFSET          ((uint8)0U)

/*! @brief Value to be used to pointer M2 params for load key */
#define CRYPTO_CSE_KE_SHE_M2_OFFSET          ((uint8)16U)

/*! @brief Value to be used to pointer M3 params for load key */
#define CRYPTO_CSE_KE_SHE_M3_OFFSET          ((uint8)48U)
/*==================================================================================================
*                                             ENUMS
==================================================================================================*/

typedef enum
{
    CRYPTO_CSE_UNINIT = 0X00U,
    CRYPTO_CSE_INIT   = 0x01U
} Crypto_Cse_InitStatusType;

/**
* @brief          Crypto_Cse_CmdType.
* @details        These are the CSE commands; they follow the same values as the SHE command definition.
*/
typedef enum
{
    CRYPTO_CSE_CMD_ENC_ECB             = 0x01,         /**< @brief AES-128 encryption in ECB mode */
    CRYPTO_CSE_CMD_ENC_CBC             = 0x02,         /**< @brief AES-128 encryption in CBC mode */
    CRYPTO_CSE_CMD_DEC_ECB             = 0x03,         /**< @brief AES-128 decryption in ECB mode */
    CRYPTO_CSE_CMD_DEC_CBC             = 0x04,         /**< @brief AES-128 decryption in CBC mode */
    CRYPTO_CSE_CMD_GENERATE_MAC        = 0x05,         /**< @brief AES-128 based CMAC generation */
    CRYPTO_CSE_CMD_VERIFY_MAC          = 0x06,         /**< @brief AES-128 based CMAC verification */
    CRYPTO_CSE_CMD_LOAD_KEY            = 0x07,         /**< @brief Internal key update */
    CRYPTO_CSE_CMD_LOAD_PLAIN_KEY      = 0x08,         /**< @brief RAM key update */
    CRYPTO_CSE_CMD_EXPORT_RAM_KEY      = 0x09,         /**< @brief RAM key export */
    CRYPTO_CSE_CMD_INIT_RNG            = 0x0A,         /**< @brief PRNG initialization */
    CRYPTO_CSE_CMD_EXTEND_SEED         = 0x0B,         /**< @brief PRNG seed entropy extension */
    CRYPTO_CSE_CMD_RND                 = 0x0C,         /**< @brief Random number generation */
    RESERVED_1                   = 0x0D,        /**< @brief RESERVED */
    CRYPTO_CSE_CMD_BOOT_FAILURE        = 0x0E,         /**< @brief Imporse sanction during invalid boot */
    CRYPTO_CSE_CMD_BOOT_OK             = 0x0F,         /**< @brief Finish boot verification */
    CRYPTO_CSE_CMD_GET_ID              = 0x10,         /**< @brief Get UID */
    CRYPTO_CSE_CMD_BOOT_DEFINE         = 0x11,         /**< @brief Secure boot configuration */
    CRYPTO_CSE_CMD_DBG_CHAL            = 0x12,         /**< @brief Get debug challenge */
    CRYPTO_CSE_CMD_DBG_AUTH            = 0x13,         /**< @brief Debug authentication */
    RESERVED_2                   = 0x14,        /**< @brief RESERVED */
    RESERVED_3                   = 0x15,        /**< @brief RESERVED */
    CRYPTO_CSE_CMD_MP_COMPRESS         = 0x16          /**< @brief Miyaguchi-Preneel compression */
} Crypto_Cse_CmdType;

/**
* @brief          Crypto_Cse_ErrorCodeType.
* @details        This type defines a predefined bitfield. The bitfield provides one bit for each error code,
*                 as per SHE specification.
*/
typedef enum
{
    CRYPTO_CSE_ERC_NO_ERROR                           = 0x0001,      /**< @brief No error has occurred and the command will be executed. */
    CRYPTO_CSE_ERC_SEQUENCE_ERROR                     = 0x0002,      /**< @brief The sequence of commands or subcommands is out of sequence. */
    CRYPTO_CSE_ERC_KEY_NOT_AVAILABLE                  = 0x0004,      /**< @brief key has DBG Attached flag and debugger is active */
    CRYPTO_CSE_ERC_KEY_INVALID                        = 0x0008,      /**< @brief A function is called to perform an operation with a key that is not allowed for the given operation. */
    CRYPTO_CSE_ERC_KEY_EMPTY                          = 0x0010,      /**< @brief Key slot is empty (not initialized)/not present or higher slot (not partitioned) */
    CRYPTO_CSE_ERC_NO_SECURE_BOOT                     = 0x0020,      /**< @brief N/A for FTFC - BOOT_DEFINE once configured, will automatically run secure boot */
    CRYPTO_CSE_ERC_KEY_WRITE_PROTECTED                = 0x0040,      /**< @brief A key update is attempted on a write protected key slot or the debugger is started while a key is write-protected. */
    CRYPTO_CSE_ERC_KEY_UPDATE_ERROR                   = 0x0080,      /**< @brief A key update did not succeed due to errors in verification of the messages. */
    CRYPTO_CSE_ERC_RNG_SEED                           = 0x0100,      /**< @brief The PRNG seed has not yet been initialized. (CSESTAT[RIN] != 1) */
    CRYPTO_CSE_ERC_NO_DEBUGGING                       = 0x0200,      /**< @brief Internal debugging is not possible because the authentication did not succeed. */
    CRYPTO_CSE_ERC_MEMORY_FAILURE                     = 0x0400,      /**< @brief General memory technology failure (multi-bit ECC error, common fault detection) */
    CRYPTO_CSE_ERC_GENERAL_ERROR                      = 0x0800,      /**< @brief Detected error that is not covered by the other error codes*/
    CRYPTO_CSE_ERC_BUSY                               = 0x1000,       /**< @brief Detected error that another command is in progress */
    CRYPTO_CSE_ERC_SMALL_BUFFER                       = 0x0FFF,       /**< @brief Detected error that small buffer */
    CRYPTO_CSE_ERC_CANCELED                           = 0xFFFF       /**< @brief Detected error that request is canceled*/
} Crypto_Cse_ErrorCodeType;

/**
* @brief          Crypto_Cse_KeyIdType.
* @details        This type specifies the key slot used to implement a requested cryptographic operation.
*/
typedef enum
{
    CRYPTO_CSE_SECRET_KEY      = 0x00,        /**< @brief Unique secret key */
    CRYPTO_CSE_MASTER_ECU      = 0x01,        /**< @brief Used for updating other memory slots */
    CRYPTO_CSE_BOOT_MAC_KEY    = 0x02,        /**< @brief Used by the secure booting mechanism to verify the authenticity of the software */
    CRYPTO_CSE_BOOT_MAC        = 0x03,        /**< @brief Stores the MAC of the Bootloader for the secure booting mechanism */
    CRYPTO_CSE_KEY_1           = 0x04,        /**< @brief User key 1 */
    CRYPTO_CSE_KEY_2           = 0x05,        /**< @brief User key 2 */
    CRYPTO_CSE_KEY_3           = 0x06,        /**< @brief User key 3 */
    CRYPTO_CSE_KEY_4           = 0x07,        /**< @brief User key 4 */
    CRYPTO_CSE_KEY_5           = 0x08,        /**< @brief User key 5 */
    CRYPTO_CSE_KEY_6           = 0x09,        /**< @brief User key 6 */
    CRYPTO_CSE_KEY_7           = 0x0A,        /**< @brief User key 7 */
    CRYPTO_CSE_KEY_8           = 0x0B,        /**< @brief User key 8 */
    CRYPTO_CSE_KEY_9           = 0x0C,        /**< @brief User key 9 */
    CRYPTO_CSE_KEY_10          = 0x0D,        /**< @brief User key 10 */
    CRYPTO_CSE_RAM_KEY         = 0x0F,        /**< @brief A volatile key that can be used for arbitrary operations */
    CRYPTO_CSE_KEY_11          = 0x14,        /**< @brief User key 11 */
    CRYPTO_CSE_KEY_12          = 0x15,        /**< @brief User key 12 */
    CRYPTO_CSE_KEY_13          = 0x16,        /**< @brief User key 13 */
    CRYPTO_CSE_KEY_14          = 0x17,        /**< @brief User key 14 */
    CRYPTO_CSE_KEY_15          = 0x18,        /**< @brief User key 15 */
    CRYPTO_CSE_KEY_16          = 0x19,        /**< @brief User key 16 */
    CRYPTO_CSE_KEY_17          = 0x1A,        /**< @brief User key 17 */
    CRYPTO_CSE_KEY_18          = 0x1B,        /**< @brief User key 18 */
    CRYPTO_CSE_KEY_19          = 0x1C,        /**< @brief User key 19 */
    CRYPTO_CSE_KEY_20          = 0x1D         /**< @brief User key 20 */
} Crypto_Cse_KeyIdType;

/**
* @brief          Crypto_Cse_CallSequenceType.
* @details        This type specifies whether the information is the first or a following function call.
*/
typedef enum
{
    CRYPTO_CSE_CALL_SEQ_FIRST      = 0x00,        /**< @brief 1st function call */
    CRYPTO_CSE_CALL_SEQ_SEQUENT    = 0x01         /**< @brief 2nd to nth function call */
} Crypto_Cse_CallSequenceType;

/**
* @brief          Crypto_Cse_FuncFormatType.
* @details        This type specifies how the data is transferred to or from the CSE. There are two use cases. 
*                 The first one implies that the data contained in the provided buffer will be copied in the CSE
*                 PRAM memory area;  the other one does not involve an additional copy of the data, the input data
*                 being provided to the CSE controller through a pointer.
*/
typedef enum
{
    CRYPTO_CSE_FUNC_FORMAT_COPY    = 0x00,        /**< @brief Parameters are copied in CSE internal RAM */
    CRYPTO_CSE_FUNC_FORMAT_ADDR    = 0x01         /**< @brief Parameters are provided as addresses in Flash space */
} Crypto_Cse_FuncFormatType;

/**
* @brief          Csec_State;
* @details        This type specifies if CRYPTO_CSE is busy with other CRYPTO_CSE commands or idle 
*/
typedef enum 
{
    CRYPTO_CSE_BUSY        = 0x00,         /**< @brief Ready to receive new commands */
    CRYPTO_CSE_IDLE        = 0x01,         /**< @brief Busy with other CRYPTO_CSE command */
} Crypto_Cse_StateType;
/*==================================================================================================
*                                STRUCTURES AND OTHER TYPEDEFS
==================================================================================================*/

/**
* @brief          Crypto_CseCommandWordType;
* @details        A 32-bit command word that has to be written to trigger the execution of a cryptographic operation.
*                 The parameters specific to each cryptographic operation have to be filled before writing the 
*                 crypto-word command.
*/
typedef uint32 Crypto_CseCommandWordType;

/**
* @brief          Initialization data for the CSE.
* @details        A pointer to such a structure is provided to the CSE initialization routines for
*                 configuration.
*/

typedef struct
{
    VAR(Crypto_Cse_CmdType, AUTOMATIC) Cmd;                                /**< @brief Cse Command */
    P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) inputdata;         /**< @brief Input data for Cse operation */
    P2VAR(Crypto_VerifyResultType, AUTOMATIC, CRYPTO_APPL_DATA) verifyPtr;
    P2VAR(uint8, AUTOMATIC, CRYPTO_APPL_DATA) outputdata;          /**< @brief Output data from Cse operation */
    VAR(Crypto_Cse_KeyIdType, AUTOMATIC) keyId;                            /**< @brief Key for Cse operation */
    VAR(uint32, AUTOMATIC) num_pages;                               /**< @brief The number of page PRAM to need store input data*/
    VAR(uint16, AUTOMATIC) page_written;                            /**< @brief The number of page PRAM have written */
    VAR(Crypto_Cse_ErrorCodeType, AUTOMATIC) eOutResponse;                 /**< @brief Status of the executed command */
    VAR(uint16, AUTOMATIC) u16MaxPages;                             /**< @brief The number of CRYPTO_CSE_PRAM pages available for data in CBC for the first iteration */
    VAR(uint32, AUTOMATIC) u32Location;                             /**< @brief Location of the Input and Output data in CBC*/
    VAR(uint32, AUTOMATIC) u32MaxBytes;                             /**< @brief Bytes are needed for the last page for generate MAC operation */
    VAR(uint32, AUTOMATIC) dataLength;                              /**< @brief Length of the Input data for generate MAC operation */
    P2CONST(uint8, AUTOMATIC, CRYPTO_APPL_CONST) SecondaryInput;    /**< @brief Pointer to the initialization vector buffer for encrypt and decrypt CBC*/
    VAR(boolean, AUTOMATIC) bRefMacWritten;                         /**< @brief Check the status of the Mac message write*/ 
    VAR(uint32, AUTOMATIC) macLength;                                /**< @brief Length of the message */
} Crypto_Cse_InitStateType;

/**
 * @brief Random key params
 */
typedef struct
{
    VAR(uint32, AUTOMATIC) destKeyIndex;
    VAR(uint32, AUTOMATIC) keySize;
    CONSTP2CONST(Crypto_KeyType, CRYPTO_VAR, CRYPTO_APPL_CONST) pCryptoKeyList;
} Crypto_Cse_RandomKeyParams;

/*
* 
* brief Get Key params
 */
typedef struct
{
    VAR(uint32, AUTOMATIC) KeyId;
    VAR(uint32, AUTOMATIC) KeyElementId;
    VAR(uint32, AUTOMATIC) LabelLength;
    CONSTP2CONST(Crypto_KeyType, CRYPTO_VAR, CRYPTO_APPL_CONST) pCryptoKeyList;
} Crypto_Cse_GetKeyParams;

/*==================================================================================================
*                                GLOBAL VARIABLE DECLARATIONS
==================================================================================================*/



/*==================================================================================================
*                                    FUNCTION PROTOTYPES
==================================================================================================*/



#ifdef __cplusplus
}
#endif

#endif /*CRYPTO_CSETYPES_H*/

/** @} */
