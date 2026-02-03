import axios from 'axios'

export const updateUser = async (updatedUserInfo) => {
    if (
    updatedUserInfo.username &&
    updatedUserInfo.first_name &&
    updatedUserInfo.last_name &&
    updatedUserInfo.email &&
    updatedUserInfo.user_id
  ) {
    const response = await axios.put(
      `/users/${updatedUserInfo.user_id}`,
      updatedUserInfo,
    )
    return response
    // const updatedUser = await updateUserInfo.data
    // return updatedUser
  } else {

    throw new Error(
      'Please provide all necessary fields for updating your user!',
    )
  }
}
